import json
import re
from pathlib import Path

def create_batch_jsonl():
    source_folder = Path("ALLSEEDS")
    template_path = Path("PromptForUpgrades.txt")
    output_file = Path("claude_batch_requests.jsonl")
    
    prompt_template = template_path.read_text()
    sfc_files = [f for f in source_folder.iterdir() if f.is_file()]
    
    print(f"Found {len(sfc_files)} files. Building Claude batch requests...")
    
    success_count = 0
    
    with open(output_file, 'w') as f:
        for sfc_file in sfc_files:
            try:
                file_content = sfc_file.read_text().strip()
                if not file_content: continue
                
                # Handle both JSON and older Python-variable formats
                if file_content.startswith('{'):
                    seed_data = json.loads(file_content)
                else:
                    local_vars = {}
                    exec(file_content, {}, local_vars)
                    seed_data = {
                        "steps": local_vars.get("steps", []),
                        "transitions": local_vars.get("transitions", []),
                        "variables": local_vars.get("variables", []),
                        "initial_step": local_vars.get("initial_step", "")
                    }
            except Exception as e:
                print(f"Skipping {sfc_file.name}: {e}")
                continue
                
            final_prompt = prompt_template.replace("{INSERT_JSON_HERE}", json.dumps(seed_data, indent=2))
            
            # --- THE FIX: Sanitize the filename for Anthropic's strict ID rules ---
            # 1. Replace anything that isn't a letter, number, underscore, or hyphen with an underscore
            safe_stem = re.sub(r'[^a-zA-Z0-9_-]', '_', sfc_file.stem)
            
            # Create 30 variations for this specific SFC
            for i in range(1, 31):
                raw_id = f"{safe_stem}_iter_{i:02d}"
                # 2. Truncate to exactly 64 characters if it's too long
                custom_id = raw_id[:64] 
                # ------------------------------------------------------------------
                
                request_obj = {
                    "custom_id": custom_id,
                    "params": {
                        "model": "claude-sonnet-4-5-20250929",
                        "max_tokens": 4096,
                        "messages": [
                            {"role": "user", "content": final_prompt}
                        ]
                    }
                }
                
                f.write(json.dumps(request_obj) + '\n')
            
            success_count += 1

    print(f"\nDone! Generated {success_count * 30} total requests in {output_file.name}.")

if __name__ == "__main__":
    create_batch_jsonl()