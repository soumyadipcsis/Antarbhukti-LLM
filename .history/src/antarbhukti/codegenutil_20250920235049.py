#!/usr/bin/env python3
"""
Code generation utilities for file operations.
This module provides utility functions for handling files and directories
in code generation workflows.
"""
import os
import json
import sys
import argparse

def gendestname(source_file, dest_root,iteration=0):
    """
    Generate destination file path by replacing the root directory.
    
    Args:
        source_file (str): Path to the source file.
        dest_root (str): Root directory for the destination.
        
    Returns:
        str: Normalized destination file path.
    """
    # Normalize the paths to handle different path separators
    basename = os.path.basename(source_file)
    (fname,ext)= os.path.splitext(basename)
    if iteration > 0:
        basename = f"{fname}_{iteration}{ext}"
    else:
        basename = f"{fname}{ext}"
    dest_root = os.path.normpath(os.path.abspath(dest_root))
    dest_file = os.path.join(dest_root, basename)
    return os.path.normpath(dest_file)


def savefile(filename, content):
    """
    Save content to a file, creating directories if needed.
    
    Args:
        filename (str): Path to the file to save.
        content (str): Content to write to the file.
    """
    f = os.path.normpath(filename)
    d = os.path.dirname(filename)
    if d and not os.path.exists(d):
        os.makedirs(d, exist_ok=True)
    with open(filename, 'w') as f:
        f.write(content)


def readfiles(root_directory):
    """
    Recursively find all text files in a directory.
    
    Args:
        root_directory (str): Root directory to search.
        
    Returns:
        list: Sorted list of absolute paths to text files.
    """
    text_files = []
    text_extensions = {'.txt', '.md', '.rst', '.log', '.csv', '.tsv', '.json', '.xml', '.yaml', '.yml', '.ini', '.cfg', '.conf'}
    
    try:
        for root, dirs, files in os.walk(root_directory):
            for file in files:
                file_path = os.path.join(root, file)
                # Get file extension
                _, ext = os.path.splitext(file)
                
                # Check if it's a text file by extension
                if ext.lower() in text_extensions:
                    text_files.append(os.path.abspath(file_path))
                # Also check files without extension that might be text
                elif not ext:
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            # Try to read a small portion to check if it's text
                            f.read(1024)
                        text_files.append(os.path.abspath(file_path))
                    except (UnicodeDecodeError, PermissionError):
                        # Skip binary files or files we can't read
                        continue
    except (OSError, PermissionError) as e:
        print(f"Error accessing directory {root_directory}: {e}")
    return sorted(text_files)


def read_config_file(config_path: str):
    """
    Read configuration file and return list of tuples (llm_name, model_name, api_key, max_tokens, max_retries, temperature, top_p, top_k, n, stop)
    
    Expected config file format (JSON):
    [
        {
            "llm_name": "gpt4o",
            "model_name": "gpt-4o",
            "api_key": "your-api-key-here",
            "max_tokens": 1500,
            "max_retries": 5,
            "temperature": 0.2,
            "top_p": 0.9,
            "top_k": 10,
            "n": 1,
            "stop": null
        },
        {
            "llm_name": "gemini",
            "model_name": "gemini-1.5-flash-001",
            "api_key": "your-api-key-here"
        },
        {
            "llm_name": "llama",
            "model_name": "llama3-8b-8192",
            "api_key": "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"
        },
        {
            "llm_name": "claude",
            "model_name": "claude-3-5-sonnet-20241022",
            "api_key": "your-anthropic-api-key-here"
        }
    ]
    """
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            config_data = json.load(f)
        
        llms = []
        for entry in config_data:
            if not all(key in entry for key in ['llm_name', 'model_name', 'api_key']):
                print(f"Warning: Skipping incomplete config entry: {entry}")
                continue
            
            # Extract mandatory fields
            llm_name = entry['llm_name']
            model_name = entry['model_name']
            api_key = entry['api_key']
            
            # Extract optional fields with default values
            max_tokens = entry.get('max_tokens', 1000)
            max_retries = entry.get('max_retries', 3)
            temperature = entry.get('temperature', 0.0)
            top_p = entry.get('top_p', 1.0)
            top_k = entry.get('top_k', 0)
            n = entry.get('n', 1)
            stop = entry.get('stop', None)
            
            llms.append((llm_name, model_name, api_key, max_tokens, max_retries, temperature, top_p, top_k, n, stop))
        
        return llms
    
    except FileNotFoundError:
        print(f"Error: Config file '{config_path}' not found.")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in config file '{config_path}': {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading config file '{config_path}': {e}")
        sys.exit(1)


def parse_args():
    """
    Parse command line arguments for SFC code generation
    
    Returns:
        argparse.Namespace: Parsed command line arguments
    """
    parser = argparse.ArgumentParser(description="SFC code upgradation and refinement tool")
    parser.add_argument("--src_path", help="Source code file or directory", required=True)
    parser.add_argument("--mod_path", required=True, help="Upgraded file or directory")
    parser.add_argument("--result_root", default="output", help="Root directory for result files")
    parser.add_argument("--prompt_path", required=True, help="Prompt file for refinement")
    parser.add_argument("--config_path", default="config.json", help="Configuration file path- defaults to 'config.json'")
    parser.add_argument("--llms", required=True, help="Choose LLMs (comma-separated)")
    args= parser.parse_args()
    # Validate source file
    if not (os.path.isfile(args.src_path) or os.path.isdir(args.src_path)):
        parser.error(f"Source file '{args.src_path}' does not exist or is not a file.")
    # Validate modified root directory
    if not (os.path.isfile(args.mod_path) or os.path.isdir(args.mod_path)):
        parser.error(f"Upgraded file '{args.mod_path}' does not exist or is not a file.")
    # Validate result root directory
    if not os.path.isdir(args.result_root):
        os.makedirs(args.result_root, exist_ok=True)
        print(f"Result root directory '{args.result_root}' does not exist. Creating one..")   
    # Validate prompt file
    if not os.path.isfile(args.prompt_path):
        parser.error(f"Prompt file '{args.prompt_path}' does not exist or is not a file.")
    # Validate config file
    if not os.path.isfile(args.config_path):
        parser.error(f"Configuration file '{args.config_path}' does not exist or is not a file.")
    # Validate LLMs argument
    if not args.llms:
        parser.error("You must specify at least one LLM using the --llms argument.")
    return args
