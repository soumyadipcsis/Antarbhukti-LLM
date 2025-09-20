import os
import sys
import argparse
import json
from abc import abstractmethod
from llm_mgr import LLM_Mgr
from codegenutil import read_config_file, parse_args
# Open AI libraries -
import openai
from langchain_openai import ChatOpenAI
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_community.callbacks import get_openai_callback

# Gemini Library - 
import google.generativeai as genai

# Groq Library for LLaMA
from groq import Groq

# Claude (Anthropic) Library
import anthropic

# to run the code, use the command - python llm_codegen.py <source_file> <prompt_file> <config_file> --llms gpt4o,gemini,grok,llama,claude
# the code generates SFC files using whatever LLM choosed earlier
# When a particular LLM is called, while generating the code, it create a folder called <llm>_Generated_Output where it saves the SFC
# code as <source_filename>_Generated_SFC.txt
# LLM_Mgr is an abstract class that is inherited by different LLM classes since they are implemented uniquely.
# LLM_Mgr class has 2 functions - generate code & save_output.

class GPT4o(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "gpt-4o"):
        super().__init__("GPT4o", model_name, api_key)
        openai.api_key = self.api_key
        self.llm = ChatOpenAI(
            model_name=self.model_name,
            temperature=self.temperature,
            streaming=False,
            verbose=False,
            api_key=self.api_key
        )

    def generate_code(self, prompt: str, src_code: str) -> str:
        messages = [
            SystemMessage(content="You are a helpful assistant for generating Sequential Function Chart (SFC) code."),
            HumanMessage(content=prompt),
            HumanMessage(content=src_code)
        ]
        try:
            with get_openai_callback() as callback:
                response = self.llm.invoke(messages)
                return response.content
        except Exception as e:
            return f"Error: {str(e)}"

    def _do_improve(self, prompt) -> str:
        """
        Improve SFC code based on the provided prompt.
        This method should be implemented by subclasses.
        """
        messages = [
            SystemMessage(content="You are a helpful assistant for improving Sequential Function Chart (SFC) code."),
            HumanMessage(content=prompt)
        ]
        try:
            with get_openai_callback() as callback:
                response = self.llm.invoke(messages)
                return response.content
        except Exception as e:
            return f"Error: {str(e)}"


class Gemini(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "gemini-1.5-flash-001"):
        super().__init__("Gemini-1.5-Flash", model_name, api_key)
        genai.configure(api_key=self.api_key)
        self.llm = genai.GenerativeModel(
            model_name=self.model_name,
            generation_config=genai.types.GenerationConfig(
                temperature=self.temperature,
                top_p=self.top_p,
                top_k= self.top_k
            )
        )

    def generate_code(self, prompt: str, src_code: str) -> str:
        try:
            response = self.llm.generate_content(f"{prompt}\n{src_code}")
            return response.text
        except Exception as e:
            return f"Error: {str(e)}"

    def _do_improve(self, prompt) -> str:
        """
        Improve SFC code based on the provided prompt.
        This method should be implemented by subclasses.
        """
        try:
            response = self.llm.generate_content(prompt)
            return response.text
        except Exception as e:
            return f"Error: {str(e)}"

class Grok(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "grok-beta"):
        super().__init__("Grok", model_name, api_key)

    def generate_code(self, prompt: str, src_code: str) -> str:
        return "Grok output."
    
    def _do_improve(self, prompt) -> str:
        """
        Improve SFC code based on the provided prompt.
        This method should be implemented by subclasses.
        """
        return NotImplementedError("Not yet implemented for Grok. Please use another LLM.")


class Claude(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "claude-3-5-sonnet-20241022"):
        super().__init__("Claude", model_name, api_key)
        self.llm = anthropic.Anthropic(api_key=self.api_key)
        print(f"[{self.name}] Using Anthropic API for Claude model access")

    def generate_code(self, prompt: str, src_code: str) -> str:
        system_message = "You are a helpful assistant for generating Sequential Function Chart (SFC) code."
        user_message = f"{prompt}\n{src_code}"
        
        try:
            print(f"[{self.name}] Generating response using Claude...")
            
            response = self.llm.messages.create(
                model=self.model_name,
                max_tokens=self.max_tokens,
                temperature=self.temperature,
                system=system_message,
                messages=[
                    {
                        "role": "user",
                        "content": user_message
                    }
                ]
            )
            return response.content[0].text

        except Exception as e:
            return f"Error: {str(e)}"

    def _do_improve(self, prompt) -> str:
        """
        Improve SFC code based on the provided prompt.
        This method should be implemented by subclasses.
        """
        system_message = "You are a helpful assistant for improving Sequential Function Chart (SFC) code."
        
        try:
            response = self.llm.messages.create(
                model=self.model_name,
                max_tokens=self.max_tokens,
                temperature=self.temperature,
                system=system_message,
                messages=[
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            )
            return response.content[0].text
        except Exception as e:
            return f"Error: {str(e)}"

class LLaMA(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "llama3-8b-8192"):
        super().__init__("LLaMA", model_name, api_key)
        self.llm = Groq(api_key=self.api_key)
        print(f"[{self.name}] Using Groq API for LLaMA model access")

    def generate_code(self, prompt: str, src_code: str) -> str:
        system_message = "You are a helpful assistant for generating Sequential Function Chart (SFC) code."
        user_message = f"{prompt}\n{src_code}"
        
        try:
            combined_prompt = f"""{system_message}

{user_message}"""

            completion = self.llm.chat.completions.create(
                model=self.model_name,
                messages=[
                    {
                        "role": "user",
                        "content": combined_prompt
                    }
                ],
                temperature=self.temperature,
                max_completion_tokens=self.max_tokens,
                top_p=self.top_p,
                stream=True,
                stop=None,
            )

            # Collect the streamed response
            response_content = ""
            print(f"[{self.name}] Generating response using LLaMA...")
            for chunk in completion:
                if chunk.choices[0].delta.content:
                    content = chunk.choices[0].delta.content
                    response_content += content
            
            print(f"[{self.name}] Response generation completed.")
            return response_content

        except Exception as e:
            return f"Error: {str(e)}"

    def _do_improve(self, prompt) -> str:
        system_message = "You are a helpful assistant for improving Sequential Function Chart (SFC) code."
        
        try:
            completion = self.llm.chat.completions.create(
                model=self.model_name,
                messages=[
                    {
                        "role": "user",
                        "content": f"{system_message}\n{prompt}"
                    }
                ],
                temperature=self.temperature,
                max_completion_tokens=self.max_tokens,
                top_p=self.top_p,
                stream=True,
                stop=None,
            )

            # Collect the streamed response
            response_content = ""
            for chunk in completion:
                if chunk.choices[0].delta.content:
                    content = chunk.choices[0].delta.content
                    response_content += content
            return response_content

        except Exception as e:
            return f"Error: {str(e)}"

def instantiate_llms(llm_names: list[str], llms_config: list):
    if not llm_names:
        print("Error: No LLMs specified.")
        sys.exit(1)
    llm_creators = {
        "gpt4o": lambda api_key, model_name: GPT4o(api_key, model_name),
        "gemini": lambda api_key, model_name: Gemini(api_key, model_name),
        "grok": lambda api_key, model_name: Grok(api_key, model_name),
        "llama": lambda api_key, model_name: LLaMA(api_key, model_name),
        "claude": lambda api_key, model_name: Claude(api_key, model_name)
    }
    if "all" in llm_names:
        llm_names = ["gpt4o", "gemini", "llama", "claude"] 

    all_llms = []
    for llm_name, model_name, api_key, max_tokens, max_retries, temperature, top_p, top_k, n, stop in llms_config:
        try:
            if llm_name.lower() not in llm_creators:
                print(f"Unknown LLM '{llm_name}'. Valid options: {', '.join(llm_creators.keys())}")
                continue   
            if not api_key or api_key.strip() == "":
                print(f"Warning: Empty API key for {llm_name}. Skipping...")
                continue
            llm_instance = llm_creators[llm_name.lower()](api_key, model_name)
            if llm_instance is None:    
                print(f"Error initializing {llm_name}. Skipping...")
                continue
            llm_instance.max_tokens = max_tokens
            llm_instance.max_retries = max_retries
            llm_instance.temperature = temperature
            llm_instance.top_p = top_p 
            llm_instance.top_k = top_k
            llm_instance.n = n
            llm_instance.stop = stop
            print(f"[{llm_name}] Initialized with model:{model_name}, Max Tokens:{llm_instance.max_tokens}, Max Retries:{llm_instance.max_retries}, Temperature:{llm_instance.temperature}, Top P:{llm_instance.top_p}, Top K:{llm_instance.top_k}, N:{llm_instance.n}, Stop:{llm_instance.stop}")
        
            all_llms.append(llm_instance)
        except Exception as e:
            print(f"Error initializing {llm_name}: {e}")
            continue
    selected_llms = []
    for llm_name in llm_names:
        llm_type = llm_name.lower()
        if llm_type.startswith("gpt"):
            llm_type = "gpt4o"
        elif llm_type.startswith("gemini"):
            llm_type = "gemini"
        elif llm_type.startswith("grok"):
            llm_type = "grok"
        elif llm_type.startswith("llama"):
            llm_type = "llama"
        elif llm_type.startswith("claude"):
            llm_type = "claude"
        selected_llms.extend([llm for llm in all_llms if llm.name.lower().startswith(llm_type)])
    if not selected_llms:
        print("Error: No valid LLMs initialized or selected.")
        sys.exit(1)
    return selected_llms

# def main():
#     args = parse_args()
#     with open(args.src_path, "r", encoding="utf-8") as f:
#         src_code = f.read()

#     with open(args.prompt_path, "r", encoding="utf-8") as f:
#         prompt = f.read()

#     # Parse requested LLM names
#     # llm_names = [name.strip().lower() for name in args.llms.split(",") if name.strip()]
#     # if "all" in llm_names:
#     #     llm_names = ["gpt4o", "gemini", "grok", "llama", "claude"] 

#     # if not llm_names:
#     #     print("Error: No LLMs specified.")
#     #     sys.exit(1)

#     # # Get all available LLMs from config
#     # # Define LLM class creators
#     # llm_creators = {
#     #     "gpt4o": lambda api_key, model_name: GPT4o(api_key, model_name),
#     #     "gemini": lambda api_key, model_name: Gemini(api_key, model_name),
#     #     "grok": lambda api_key, model_name: Grok(api_key, model_name),
#     #     "llama": lambda api_key, model_name: LLaMA(api_key, model_name),
#     #     "claude": lambda api_key, model_name: Claude(api_key, model_name)
#     # }
    
#     # all_llms = get_llms_by_names(args.config_path, llm_creators)
    
#     # # Filter LLMs based on user selection
#     # selected_llms = []
#     # for llm in all_llms:
#     #     llm_type = llm.name.lower()
#     #     if llm_type.startswith("gpt"):
#     #         llm_type = "gpt4o"
#     #     elif llm_type.startswith("gemini"):
#     #         llm_type = "gemini"
#     #     elif llm_type.startswith("grok"):
#     #         llm_type = "grok"
#     #     elif llm_type.startswith("llama"):
#     #         llm_type = "llama"
#     #     elif llm_type.startswith("claude"):
#     #         llm_type = "claude"
        
#     #     if llm_type in llm_names:
#     #         selected_llms.append(llm)

#     # if not selected_llms:
#     #     print("Error: No valid LLMs initialized or selected.")
#     #     sys.exit(1)

#     # for llm in selected_llms:
#     #     print(f"\n>>> Running {llm.name}...")
#     #     output = llm.generate_code(prompt, src_code)
#     #     llm.save_output(output, args.src_path)

# if __name__ == "__main__":
#     main()