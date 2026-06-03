import os
import json
import re
import shutil
from pathlib import Path

# --- Configuration ---
LAYER_1_DIR = Path("layer1")
CORRUPTED_DIR = Path("layer1_corrupted")

def is_file_valid(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            raw_content = f.read()

        # 1. Try parsing the outer wrapper (Claude's JSON structure)
        data = json.loads(raw_content)
        text_content = data.get("generation", "")

        # 2. Check if the XML tags were successfully closed
        sfc_match = re.search(r'<SFC_upgraded>\s*(.*?)\s*</SFC_upgraded>', text_content, re.DOTALL)
        if not sfc_match:
            return False # Truncated before the closing tag

        # 3. Try parsing the actual SFC logic inside the tags
        sfc_upgraded_str = sfc_match.group(1).strip()
        
        # If this fails, Claude closed the tag but mangled the JSON inside
        json.loads(sfc_upgraded_str) 
        
        return True # The file is perfectly intact
        
    except (json.JSONDecodeError, AttributeError):
        return False # Caught a structural JSON cutoff

def main():
    if not LAYER_1_DIR.exists():
        print(f"Error: Directory '{LAYER_1_DIR}' not found.")
        return

    # Create the quarantine folder if it doesn't exist
    CORRUPTED_DIR.mkdir(exist_ok=True)
    
    good_count = 0
    bad_count = 0

    print(f"Scanning '{LAYER_1_DIR}' for truncated outputs...")
    
    for filepath in LAYER_1_DIR.glob("*.json"):
        if is_file_valid(filepath):
            good_count += 1
        else:
            # Evict the corrupted file
            shutil.move(str(filepath), str(CORRUPTED_DIR / filepath.name))
            bad_count += 1

    print("\n=== Cleanup Complete ===")
    print(f"Perfect Files:   {good_count} (Remaining in '{LAYER_1_DIR}')")
    print(f"Truncated Files: {bad_count} (Moved to '{CORRUPTED_DIR}')")

if __name__ == "__main__":
    main()