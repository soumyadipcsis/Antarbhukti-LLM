import os
import sys
from abc import abstractmethod
from llm_mgr import LLM_Mgr
from codegenutil import read_config_file, parse_args
# Open AI libraries
import openai
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_community.callbacks import get_openai_callback
# Gemini Library
import google.generativeai as genai
# Groq Library for LLaMA
from groq import Groq
# Claude (Anthropic) Library
import anthropic

class GPT4o(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "gpt-4o"):
        super().__init__("GPT4o", model_name, api_key)
        openai.api_key = self.api_key
        self.llm = ChatOpenAI(model_name=self.model_name, temperature=self.temperature, api_key=self.api_key)

    def _get_response_with_callbacks(self, messages):
        try:
            with get_openai_callback() as callback:
                response = self.llm.invoke(messages)
                token_usage = callback.total_tokens
                print(f"[{self.name}] Token usage - Total: {token_usage}, Cost: ${callback.total_cost:.5f}")
                return response.content, token_usage
        except Exception as e:
            return f"Error: {str(e)}", None

    def generate_code(self, prompt: str, src_code: str):
        messages = [
            SystemMessage(content="You are a helpful assistant for generating Sequential Function Chart (SFC) code."),
            HumanMessage(content=f"{prompt}\n{src_code}")
        ]
        return self._get_response_with_callbacks(messages)

    def _do_improve(self, prompt: str):
        messages = [
            SystemMessage(content="You are a helpful assistant for improving Sequential Function Chart (SFC) code."),
            HumanMessage(content=prompt)
        ]
        return self._get_response_with_callbacks(messages)

class Gemini(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "gemini-1.5-flash-001"):
        super().__init__("Gemini-1.5-Flash", model_name, api_key)
        genai.configure(api_key=self.api_key)
        self.llm = genai.GenerativeModel(model_name=self.model_name)

    def _get_response_and_tokens(self, content: str):
        try:
            response = self.llm.generate_content(content)
            total_tokens = response.usage_metadata.total_token_count if hasattr(response, 'usage_metadata') else None
            print(f"[{self.name}] Token usage - Total: {total_tokens}")
            return response.text, total_tokens
        except Exception as e:
            return f"Error: {str(e)}", None

    def generate_code(self, prompt: str, src_code: str):
        return self._get_response_and_tokens(f"{prompt}\n{src_code}")

    def _do_improve(self, prompt: str):
        return self._get_response_and_tokens(prompt)

class Grok(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "grok-beta"):
        super().__init__("Grok", model_name, api_key)
    
    def generate_code(self, prompt: str, src_code: str):
        print("[Grok] Not implemented.")
        return "Not implemented.", 0
    
    def _do_improve(self, prompt) -> str:
        print("[Grok] Not implemented.")
        return "Not implemented.", 0

class Claude(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "claude-3-5-sonnet-20240620"):
        super().__init__("Claude", model_name, api_key)
        self.llm = anthropic.Anthropic(api_key=self.api_key)

    def _get_response_and_tokens(self, system_message: str, user_message: str):
        try:
            response = self.llm.messages.create(
                model=self.model_name,
                max_tokens=self.max_tokens,
                temperature=self.temperature,
                system=system_message,
                messages=[{"role": "user", "content": user_message}]
            )
            total_tokens = (response.usage.input_tokens + response.usage.output_tokens) if hasattr(response, 'usage') else None
            print(f"[{self.name}] Token usage - Total: {total_tokens}")
            return response.content[0].text, total_tokens
        except Exception as e:
            return f"Error: {str(e)}", None

    def generate_code(self, prompt: str, src_code: str):
        system_message = "You are a helpful assistant for generating Sequential Function Chart (SFC) code."
        return self._get_response_and_tokens(system_message, f"{prompt}\n{src_code}")

    def _do_improve(self, prompt: str):
        system_message = "You are a helpful assistant for improving Sequential Function Chart (SFC) code."
        return self._get_response_and_tokens(system_message, prompt)

class LLaMA(LLM_Mgr):
    def __init__(self, api_key: str, model_name: str = "llama3-8b-8192"):
        super().__init__("LLaMA", model_name, api_key)
        self.llm = Groq(api_key=self.api_key)

    def _get_response_and_tokens(self, user_message: str):
        try:
            completion = self.llm.chat.completions.create(
                model=self.model_name,
                messages=[{"role": "user", "content": user_message}],
                stream=True,
            )
            response_content = "".join(chunk.choices[0].delta.content for chunk in completion if chunk.choices[0].delta.content)
            usage = completion.get_final_usage_metrics()
            total_tokens = getattr(usage, "total_tokens", None)
            print(f"[{self.name}] Token usage - Total: {total_tokens}")
            return response_content, total_tokens
        except Exception as e:
            return f"Error: {str(e)}", None

    def generate_code(self, prompt: str, src_code: str):
        system_message = "You are a helpful assistant for generating Sequential Function Chart (SFC) code."
        return self._get_response_and_tokens(f"{system_message}\n\n{prompt}\n{src_code}")

    def _do_improve(self, prompt: str):
        system_message = "You are a helpful assistant for improving Sequential Function Chart (SFC) code."
        return self._get_response_and_tokens(f"{system_message}\n{prompt}")

def instantiate_llms(llm_names: list[str], llms_config: list):
    # This function remains unchanged but will work with the corrected classes.
    if not llm_names:
        print("Error: No LLMs specified.")
        sys.exit(1)
    llm_creators = {
        "gpt4o": GPT4o,
        "gemini": Gemini,
        "grok": Grok,
        "llama": LLaMA,
        "claude": Claude
    }
    if "all" in llm_names:
        llm_names = ["gpt4o", "gemini", "llama", "claude"]

    all_llms = []
    config_map = {cfg[0].lower(): cfg for cfg in llms_config}

    for name in llm_names:
        if name.lower() in config_map:
            llm_name, model_name, api_key, max_tokens, _, temp, top_p, top_k, _, _ = config_map[name.lower()]
            try:
                if not api_key or not api_key.strip():
                    print(f"Warning: Empty API key for {llm_name}. Skipping...")
                    continue
                llm_instance = llm_creators[llm_name.lower()](api_key, model_name)
                llm_instance.max_tokens = int(max_tokens)
                llm_instance.temperature = float(temp)
                llm_instance.top_p = float(top_p)
                llm_instance.top_k = int(top_k)
                print(f"[{llm_name}] Initialized with model: {model_name}")
                all_llms.append(llm_instance)
            except Exception as e:
                print(f"Error initializing {name}: {e}")
    
    if not all_llms:
        print("Error: No valid LLMs were initialized.")
        sys.exit(1)
    return all_llms