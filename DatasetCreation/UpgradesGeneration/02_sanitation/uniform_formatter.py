import os
import json
import re
from pathlib import Path

# --- Configuration ---
# Folders containing the generated outputs (from your split)
TRAIN_DIR = Path("final_dataset/train")
TEST_DIR = Path("final_dataset/test")

# Folders containing the baseline files
RAW_OSCAT_DIR = Path("ALLSEEDS") # The original 280 baseline files
LAYER_1_DIR = Path("layer1")     # Needed to serve as the baseline for Layer 2 files

def extract_tags(text_content):
    """Extracts the NL prompt(s) and Upgraded SFC from the XML tags using Regex."""
    # Find ALL prompt blocks, not just the first one
    nl_matches = re.findall(r'<NL_upgradation_prompt>\s*(.*?)\s*</NL_upgradation_prompt>', text_content, re.DOTALL)
    sfc_match = re.search(r'<SFC_upgraded>\s*(.*?)\s*</SFC_upgraded>', text_content, re.DOTALL)
    
    # Stitch multiple prompts together with a clear separator
    nl_prompt = "\n\n[AND]\n\n".join([match.strip() for match in nl_matches]) if nl_matches else None
    
    sfc_upgraded_str = sfc_match.group(1).strip() if sfc_match else None
    
    sfc_upgraded = None
    if sfc_upgraded_str:
        try:
            sfc_upgraded = json.loads(sfc_upgraded_str)
        except json.JSONDecodeError:
            print("  [!] Error decoding JSON inside <SFC_upgraded>")
            
    return nl_prompt, sfc_upgraded

def process_file(filepath):
    # 1. Read the file content
    with open(filepath, 'r', encoding='utf-8') as f:
        raw_content = f.read()
        
    filename = filepath.stem
    
    # 2. Handle the two different formats
    is_layer_2 = "_L2_" in filename
    layer_num = 2 if is_layer_2 else 1
    
    # Try to load as Layer 1 JSON format first
    try:
        data = json.loads(raw_content)
        text_to_parse = data.get("generation", "")
    except json.JSONDecodeError:
        # If it fails, it's the Layer 2 raw text format
        text_to_parse = raw_content

    # 3. Extract the components
    nl_prompt, sfc_upgraded = extract_tags(text_to_parse)
    if not nl_prompt or not sfc_upgraded:
        print(f"Skipping {filename}: Missing tags or invalid JSON.")
        return None

    # 4. Map the correct Baseline (sfc1)
    sfc_baseline = None
    if layer_num == 1:
        # Baseline is the original OSCAT file (.txt extension)
        if "_sfc_iter" in filename:
            seed_name = filename.split("_sfc_iter")[0]
            base_path = RAW_OSCAT_DIR / f"{seed_name}_sfc.txt"
        else:
            seed_name = filename.split("_iter")[0]
            base_path = RAW_OSCAT_DIR / f"{seed_name}.txt"
    else:
        # Baseline is the Layer 1 file it was built on
        l1_filename = filename.split("_L2_")[0] + ".json"
        base_path = LAYER_1_DIR / l1_filename
        
    # Read the baseline file
    if base_path.exists():
        with open(base_path, 'r', encoding='utf-8') as bf:
            try:
                # If the baseline is a Layer 1 file, we only want its final upgraded JSON
                if layer_num == 2:
                    bf_content = bf.read()
                    try:
                        bf_json = json.loads(bf_content)
                        _, sfc_baseline = extract_tags(bf_json.get("generation", ""))
                    except:
                        _, sfc_baseline = extract_tags(bf_content)
                else:
                    # If it's an original OSCAT file, just read the JSON
                    sfc_baseline = json.load(bf)
            except json.JSONDecodeError:
                print(f"  [!] Error decoding baseline JSON: {base_path}")
    else:
        print(f"  [!] Missing baseline file: {base_path}")
        return None

    # 5. Build the final Uniform Triplet
    return {
        "id": filename,
        "layer": layer_num,
        "sfc_baseline": sfc_baseline,
        "nl_prompt": nl_prompt,
        "sfc_upgraded": sfc_upgraded
    }

def format_directory(directory_path):
    print(f"\nProcessing {directory_path}...")
    for filepath in directory_path.glob("*.json"):
        unified_data = process_file(filepath)
        
        if unified_data:
            # Overwrite the file with the clean, uniform JSON schema
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(unified_data, f, indent=2)

if __name__ == "__main__":
    format_directory(TRAIN_DIR)
    format_directory(TEST_DIR)
    print("\nFormatting Complete! The dataset is now completely uniform and ready for training.")