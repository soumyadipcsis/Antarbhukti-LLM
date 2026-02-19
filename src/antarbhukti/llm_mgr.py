import os
from abc import ABC, abstractmethod
#from langchain_core.messages import HumanMessage

class LLM_Mgr(ABC):
    def __init__(self, name: str, model_name: str, api_key: str):
        self.name = name
        self.llm = None
        self.api_key = api_key
        self.model_name = model_name
        self.max_tokens= 4000 #Max tokens for the response
        self.max_retries = 3 #Max retries for LLM calls
        self.temperature = 0.0 # Temperature for LLM response variability
        self.top_p = 1.0  # Top-p sampling for LLM response
        self.top_k = 0  # Top-k sampling for LLM response
        self.n = 1  # Number of responses to generate
        self.stop = None  # Stop sequences for LLM response
    
    @abstractmethod
    def generate_code(self, prompt: str, src_code: str) -> str:
       pass
    @abstractmethod
    def _do_improve(self, prompt) -> str:
        """
        Abstract method to improve SFC code based on the prompt.
        This should be implemented by subclasses.
        """
        pass
    def save_output(self, output: str, original_file: str):
        folder = f"{self.name}_Generated_Output"
        os.makedirs(folder, exist_ok=True)
        output_file = os.path.join(folder, os.path.splitext(os.path.basename(original_file))[0] + "_Generated_SFC.txt")
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(output)
        print(f"[{self.name}] Output saved to: {output_file}")


    def generate_prompt(self, orig, modified, unmatched_paths,
        prompt_template_path="iterative_prompting.txt",  ## This file contain the prompt template
        prompt_path="prompt_refiner.txt", 
        # Initially it is same as prompt_template_path
        # But after the LLM response, it will be updated with the new prompt
        #sfc2_path="dec2hex_mod.txt" # Path to save the improved SFC2 code
    ):
        if not unmatched_paths:  # Early exit if there are no unmatched paths to improve
            print("No unmatched paths to improve on.")
            return None

        # Prepare the header for unmatched paths table in the prompt
        table_lines = ["From\tTo\tTransitions\tCondition\tData Transformation"]
        for p in unmatched_paths:  # Loop through each unmatched path and build a row
            row = [
                str(p.get("from", "")),  # From step
                str(p.get("to", "")),    # To step
                str(p.get("transitions", "")),  # Transition(s)
                str(p.get("cond", "")),  # Z3 condition
                str(p.get("subst", ""))  # Z3 data transformation
            ]
            table_lines.append("\t".join(row))  # Add the row to the table
        non_equiv = "\n".join(table_lines)  # Join all rows for the prompt

        # Prepare SFC2 and SFC1 step/transition code strings for the prompt
        mod_code = f"steps2 = {repr(modified.steps)}\ntransitions2 = {repr(modified.transitions)}"
        orig_code = f"steps1 = {repr(orig.steps)}\ntransitions1 = {repr(orig.transitions)}"

        # Read the interative_prompting.txt  file
        with open(prompt_template_path, "r") as f:
            prompt_template = f.read()

        # Fill the template with the current iteration's data
        prompt = prompt_template.format(non_equiv_paths_str=non_equiv, sfc2_code=mod_code, sfc1_code=orig_code)

        # Save the completed prompt (with all placeholders filled) to a file for reproducibility and debugging
        with open(prompt_path, "w") as f:
            f.write(prompt)
        return prompt  # Return the generated prompt string
        #print(f"Saved LLM prompt to {prompt_path}")

    def improve_code(self, prompt, modified, sfc2_path):
        # Send the prompt to the LLM and get the response
        llm_response, token_usage = self._do_improve(prompt)

        # Save the raw output for debugging
        if self.name.lower() == "claude":
            with open("claude_raw_output.txt", "w", encoding="utf-8") as f:
                f.write(llm_response)

        if self.name.lower() == "gemini":
            with open("gemini_raw_output.txt", "w", encoding="utf-8") as f:
                f.write(llm_response)
        
        # Check for API error in the response
        lower = llm_response.lower()
        if (
            "error" in lower
            and ("403" in lower or "api key" in lower or "not found" in lower)
        ):
            error_msg = llm_response.strip()
            print(f"\n[{self.name} API Error]")
            print(error_msg)
            return {
                "improved": False,
                "error": error_msg,
                "token_usage": token_usage,
                "llm_time": 0
            }


        # Extract the code block (steps2, transitions2) from the LLM response
        code_block = self.extract_code_block(llm_response)
        if not code_block:
            print("No valid code block found.")
            return {
                "improved": False,
                "error": "No valid code block found.",
                "token_usage": token_usage,
                "llm_time": 0
            }

        # Evaluate the code block to get steps2 and transitions2
        local_vars = {}
        try:
            exec(code_block, {}, local_vars)
            steps2 = local_vars.get("steps2")
            transitions2 = local_vars.get("transitions2")
            if steps2 is None or transitions2 is None:
                raise ValueError("steps2 or transitions2 not found in code block.")
        except Exception as e:
            error_msg = f"Error parsing LLM output: {e}"
            print(error_msg)
            return {
                "improved": False,
                "error": error_msg,
                "token_usage": token_usage,
                "llm_time": 0
            }

        # Helper functions to format output
        def format_list_of_dicts(name, lst):
            import json
            lines = [f"{name} = [\n"]
            for d in lst:
                lines.append("    " + json.dumps(d) + ",\n")
            lines.append("    ]\n")
            return "".join(lines)

        def format_list(name, lst):
            vals = ", ".join(f'"{v}"' for v in lst)
            return f"{name} = [{vals}]\n"

        def format_string(name, value):
            return f"{name} = \"{value}\"\n"

        # Save the improved SFC2 to file for the next iteration
        with open(sfc2_path, "w") as f:
            f.write(format_list_of_dicts("steps", steps2))
            f.write(format_list_of_dicts("transitions", transitions2))
            f.write(format_list("variables", modified.variables))
            f.write(format_string("initial_step", modified.initial_step))

        return {"improved": True, "token_usage": token_usage}

    # def improve_sfc(self, prompt):
    #     response = self.llm.invoke([HumanMessage(content=prompt)])  # Send the prompt to the LLM and get response
    #     return response.content  # Return LLM response as string

    @staticmethod
    def extract_code_block(llm_output):
        import re  # Import regular expressions module
        # Try to find a Python code block in the LLM output
        match = re.search(r"```(?:python)?\s*([\s\S]*?)```", llm_output)
        if match:
            return match.group(1)  # Return code inside code block
        # Fallback for models that don't use markdown blocks
        lines = llm_output.splitlines()
        extracted_code = []
        in_list = False
        for line in lines:
            stripped_line = line.strip()
            if stripped_line.startswith("steps2") or stripped_line.startswith("transitions2"):
                in_list = True
            
            if in_list:
                extracted_code.append(line)
                if stripped_line.endswith("]"):
                    in_list = False

        return "\n".join(extracted_code)

    @staticmethod
    def sfc2_code_to_python(sfc2_code_str):
        local_vars = {}  # Create a dict for local variables
        exec(sfc2_code_str, {}, local_vars)  # Execute the code string in a restricted namespace
        return local_vars["steps2"], local_vars["transitions2"]  # Return the extracted values
