import json
from pathlib import Path

def create_batch_jsonl():
    source_folder = Path("ALLSEEDS") 
    template_path = Path("PromptForUpgrades.txt")
    output_file = Path("sfc_batch_requests.jsonl")
    
    prompt_template = template_path.read_text()
    sfc_files = [f for f in source_folder.iterdir() if f.is_file()]
    
    print(f"Found {len(sfc_files)} files. Building batch requests...")
    
    success_count = 0
    
    with open(output_file, 'w') as f:
        for sfc_file in sfc_files:
            try:
                file_content = sfc_file.read_text().strip()
                if not file_content:
                    print(f"Skipping {sfc_file.name}: File is completely empty.")
                    continue
                
                # --- THE FIX: Handle both JSON and Python-style formats ---
                if file_content.startswith('{'):
                    # It's your new, correct JSON format
                    seed_data = json.loads(file_content)
                else:
                    # It's your older Python variable format
                    local_vars = {}
                    # Execute the file's text as Python code and store variables in local_vars
                    exec(file_content, {}, local_vars) 
                    
                    # Reconstruct it into standard JSON structure
                    seed_data = {
                        "steps": local_vars.get("steps", []),
                        "transitions": local_vars.get("transitions", []),
                        "variables": local_vars.get("variables", []),
                        "initial_step": local_vars.get("initial_step", "")
                    }
                # ----------------------------------------------------------

            except Exception as e:
                print(f"Skipping {sfc_file.name}: Could not parse. Error: {e}")
                continue
            
            # Inject the standard JSON into the prompt
            final_prompt = prompt_template.replace("{INSERT_JSON_HERE}", json.dumps(seed_data, indent=2))
            
            # Create 30 variations for this specific SFC
            for i in range(1, 31):
                custom_id = f"{sfc_file.stem}_iter_{i:02d}"
                
                request_obj = {
                    "custom_id": custom_id,
                    "method": "POST",
                    "url": "/v1/chat/completions",
                    "body": {
                        "model": "gpt-4o",
                        "messages": [
                            {"role": "user", "content": final_prompt}
                        ],
                        "temperature": 1.0,
                        "max_tokens": 4096
                    }
                }
                
                f.write(json.dumps(request_obj) + '\n')
            
            success_count += 1

    print(f"\nDone! Successfully processed {success_count}/{len(sfc_files)} files.")
    print(f"Generated {success_count * 30} total requests in {output_file.name}.")

if __name__ == "__main__":
    create_batch_jsonl()