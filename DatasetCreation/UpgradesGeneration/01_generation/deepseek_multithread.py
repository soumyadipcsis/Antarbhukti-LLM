import json
import os
import concurrent.futures
import threading
from pathlib import Path
from openai import OpenAI

# --- CONFIGURATION ---
API_KEY = "sk-XXX"  # Replace with your actual DeepSeek API key
INPUT_FILE = "layer2_batch_requests.jsonl" 
OUTPUT_DIR = Path("TEST_upgraded_sfcs_layer2")
MAX_WORKERS = 50  # DeepSeek allows high concurrency; 50 is a safe start

# DeepSeek uses the OpenAI SDK format natively
client = OpenAI(api_key=API_KEY, base_url="https://api.deepseek.com")
OUTPUT_DIR.mkdir(exist_ok=True)

# Thread-safe counter
progress_lock = threading.Lock()
completed_count = 0
total_tasks = 0

def process_task(task_line):
    global completed_count
    try:
        task = json.loads(task_line)
        custom_id = task.get("custom_id")
        
        if not custom_id:
            return

        out_file = OUTPUT_DIR / f"{custom_id}.json"
        if out_file.exists():
            return  # Skip if already successfully processed

        # Extract the DeepSeek/OpenAI formatted messages
        body = task.get("body", {})
        messages = body.get("messages", [])

        # Fire request to DeepSeek
        # Extract messages and temperature from the JSONL payload
        body = task.get("body", {})
        messages = body.get("messages", [])
        task_temp = body.get("temperature", 0.3) # Defaults to 0.3 if not found

        # Fire request to DeepSeek
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=messages,
            temperature=task_temp
        )
        
        result_text = response.choices[0].message.content
        
        # Save directly to the output folder
        with open(out_file, "w", encoding="utf-8") as f:
            f.write(result_text)

    except Exception as e:
        print(f"Error on ID {custom_id}: {str(e)}")
        
    finally:
        with progress_lock:
            completed_count += 1
            if completed_count % 50 == 0:
                print(f"Progress: {completed_count}/{total_tasks} completed.")

def main():
    global total_tasks
    
    if not os.path.exists(INPUT_FILE):
        print(f"Error: {INPUT_FILE} not found.")
        return

    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        tasks = [line.strip() for line in f if line.strip()]
    #slice the list for testing (remove later.)
    tasks = tasks[:20]
        
    total_tasks = len(tasks)
    print(f"Starting multi-threaded execution for {total_tasks} tasks using {MAX_WORKERS} workers...")

    # Execute threads concurrently
    with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        executor.map(process_task, tasks)

    print("Execution complete. Check the upgraded_sfcs folder.")

if __name__ == "__main__":
    main()