import os
from abc import ABC, abstractmethod

class LLM_Mgr(ABC):
    def __init__(self, name: str, model_name: str, api_key: str):
        self.name = name
        self.llm = None
        self.api_key = api_key
        self.model_name = model_name
        self.max_tokens= 4096 # Increased max tokens for potentially larger responses
        self.max_retries = 3
        self.temperature = 0.0
        self.top_p = 1.0
        self.top_k = 0
        self.n = 1
        self.stop = None
    
    @abstractmethod
    def generate_code(self, prompt: str, src_code: str):
       pass

    @abstractmethod
    def _do_improve(self, prompt: str):
        pass

    def save_output(self, output: str, original_file: str):
        folder = f"{self.name}_Generated_Output"
        os.makedirs(folder, exist_ok=True)
        output_file = os.path.join(folder, os.path.splitext(os.path.basename(original_file))[0] + "_Generated_SFC.txt")
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(output)
        print(f"[{self.name}] Output saved to: {output_file}")

    def generate_prompt(self, orig, modified, unmatched_paths, prompt_template_path="iterative_prompting.txt"):
        if not unmatched_paths:
            print("No unmatched paths to improve on.")
            return None

        table_lines = ["From\tTo\tTransitions\tCondition\tData Transformation"]
        for p in unmatched_paths:
            trace_str = "".join([event["concept:name"] for event in p])
            table_lines.append(trace_str)
        non_equiv = "\n".join(table_lines)

        mod_code = f"steps2 = {repr(modified.steps)}\ntransitions2 = {repr(modified.transitions)}"
        orig_code = f"steps1 = {repr(orig.steps)}\ntransitions1 = {repr(orig.transitions)}"

        with open(prompt_template_path, "r") as f:
            prompt_template = f.read()

        prompt = prompt_template.format(non_equiv_paths_str=non_equiv, sfc2_code=mod_code, sfc1_code=orig_code)
        
        # Save the prompt for debugging
        with open("prompt_refiner.txt", "w") as f:
            f.write(prompt)
        return prompt

    def improve_code(self, prompt, modified, sfc2_path):
        """
        Calls the LLM to improve the code and returns a tuple of (success_boolean, token_count).
        """
        # --- MODIFICATION START ---
        # This now correctly expects and handles the token count from _do_improve.
        llm_response, total_tokens = self._do_improve(prompt)

        if llm_response is None or "Error:" in llm_response:
            print(f"LLM call failed: {llm_response}")
            return False, total_tokens # Return token count even on failure

        with open("llm_response.txt", "w") as f:
            f.write(llm_response)

        code_block = self.extract_code_block(llm_response)
        if not code_block:  
            print("No valid code block found in LLM output.")
            return False, total_tokens # Return token count on failure

        try:
            steps2, transitions2 = self.sfc2_code_to_python(code_block)
        except Exception as e:
            print(f"Error parsing LLM output: {e}")
            return False, total_tokens # Return token count on failure
        # --- MODIFICATION END ---

        # Helper to format a list of dicts into a Python-like string
        def format_list_of_dicts(name, lst):
            lines = [f"{name} = ["]
            for item in lst:
                lines.append(f"    {repr(item)},")
            lines.append("]\n")
            return "".join(lines)
        
        def format_list(name, lst):
            return f"{name} = {repr(lst)}\n"

        def format_string(name, value):
            return f"{name} = {repr(value)}\n"

        with open(sfc2_path, "w") as f:
            f.write(format_list_of_dicts("steps", steps2))  
            f.write(format_list_of_dicts("transitions", transitions2)) 
            f.write(format_list("variables", modified.variables)) 
            f.write(format_string("initial_step", modified.initial_step))  
        
        return True, total_tokens # Return success and the token count

    @staticmethod
    def extract_code_block(llm_output):
        import re
        match = re.search(r"```(?:python)?\s*([\s\S]*?)```", llm_output)
        if match:
            return match.group(1).strip()
        
        lines = []
        in_code_block = False
        for line in llm_output.splitlines():
            if line.strip().startswith("steps2 ="):
                in_code_block = True
            if in_code_block:
                lines.append(line)
        return "\n".join(lines) if lines else llm_output

    @staticmethod
    def sfc2_code_to_python(sfc2_code_str):
        local_vars = {}
        # Ensure the code string is executable
        if not sfc2_code_str.strip().startswith("steps2 ="):
            sfc2_code_str = "steps2 = " + sfc2_code_str
        exec(sfc2_code_str, {}, local_vars)
        return local_vars["steps2"], local_vars.get("transitions2", [])