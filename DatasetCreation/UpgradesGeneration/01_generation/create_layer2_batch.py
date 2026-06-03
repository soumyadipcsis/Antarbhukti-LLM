import json
import re
from pathlib import Path

def create_layer2_batch():
    source_folder = Path("upgraded_sfcs")
    template_path = Path("PromptForUpgrades.txt")
    output_file = Path("layer2_batch_requests.jsonl")
    
    prompt_template = template_path.read_text()
    l1_files = [f for f in source_folder.iterdir() if f.is_file() and f.suffix == '.json']
    
    print(f"Found {len(l1_files)} Layer 1 files. Extracting and building Layer 2 requests...")
    
    success_count = 0
    ITERATIONS_PER_SEED = 3 # You mentioned 3 upgrades per Layer 1 seed
    
    with open(output_file, 'w', encoding='utf-8') as f:
        for l1_file in l1_files:
            try:
                # 1. Load the Layer 1 generation
                l1_data = json.loads(l1_file.read_text(encoding='utf-8'))
                generation_text = l1_data.get("generation", "")
                
                # 2. Extract ONLY the JSON between the <SFC_upgraded> tags
                json_match = re.search(r'<SFC_upgraded>(.*?)</SFC_upgraded>', generation_text, re.DOTALL | re.IGNORECASE)
                
                if not json_match:
                    print(f"Skipping {l1_file.name}: Could not find <SFC_upgraded> tags.")
                    continue
                    
                raw_json_str = json_match.group(1).strip()
                
                # Clean up any accidental markdown blocks Claude might have inserted
                clean_json_str = re.sub(r'^```json\s*|```\s*$', '', raw_json_str)
                
                # 3. Parse to ensure it's valid JSON, then dump it minified to save tokens
                l1_sfc_dict = json.loads(clean_json_str)
                minified_seed_json = json.dumps(l1_sfc_dict, separators=(',', ':'))
                
            except Exception as e:
                print(f"Skipping {l1_file.name}: Parsing error -> {e}")
                continue
                
            # 4. Inject the Layer 1 SFC as the new seed for Layer 2
            final_prompt = prompt_template.replace("{INSERT_JSON_HERE}", minified_seed_json)
            
            # 5. Generate the 3 variations for DeepSeek/OpenAI
            for i in range(1, ITERATIONS_PER_SEED + 1):
                # We append L2 to the ID to track its lineage
                custom_id = f"{l1_file.stem}_L2_iter_{i:02d}" 
                
                # Format for DeepSeek/OpenAI 
                request_obj = {
                    "custom_id": custom_id,
                    "method": "POST",
                    "url": "/v1/chat/completions",
                    "body": {
                        "model": "deepseek-chat", # Or gpt-4o-mini
                        "messages": [
                            {"role": "user", "content": final_prompt}
                        ],
                        "temperature": 0.3,
                        "max_tokens": 4096
                    }
                }
                
                f.write(json.dumps(request_obj) + '\n')
            
            success_count += 1

    print(f"\nDone! Successfully parsed {success_count} Layer 1 files.")
    print(f"Generated {success_count * ITERATIONS_PER_SEED} total requests in {output_file.name}.")

if __name__ == "__main__":
    create_layer2_batch()