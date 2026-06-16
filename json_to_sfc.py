import json
import sys
from pathlib import Path

# =====================================================================
# CONFIGURATION
# Set to: 'baseline', 'upgraded', or 'prompt'
# =====================================================================
TARGET_EXTRACTION = 'baseline' 
# =====================================================================

def format_sfc_to_antarbhukti(sfc_data):
    """Converts a raw JSON SFC dictionary into the Antarbhukti Python format."""
    steps = sfc_data.get("steps", [])
    transitions = sfc_data.get("transitions", [])
    variables = sfc_data.get("variables", [])
    initial_step = sfc_data.get("initial_step", "")

    lines = []
    
    # 1. Format Steps
    lines.append("steps = [")
    for i, step in enumerate(steps):
        comma = "," if i < len(steps) - 1 else ""
        lines.append(f"{json.dumps(step)}{comma}")
    lines.append("]")

    # 2. Format Transitions
    lines.append("transitions = [")
    for i, tran in enumerate(transitions):
        # Normalize booleans for Python
        tran["guard"] = tran["guard"].replace("TRUE", "True").replace("FALSE", "False")
        comma = "," if i < len(transitions) - 1 else ""
        lines.append(f"{json.dumps(tran)}{comma}")
    lines.append("]")

    # 3. Format Variables & Initial Step
    lines.append(f"variables = {json.dumps(variables)}")
    lines.append(f"initial_step = '{initial_step}'")
    
    return "\n".join(lines)

def process_file(input_path):
    with open(input_path, "r") as f:
        data = json.load(f)

    # Automatically name the output file based on the extraction target
    output_path = input_path.with_name(f"{input_path.stem}_{TARGET_EXTRACTION}.txt")

    # Route based on the developer's setting
    if TARGET_EXTRACTION == 'baseline':
        if "sfc_baseline" not in data:
            print(f"Error: 'sfc_baseline' not found in {input_path.name}")
            sys.exit(1)
        output_content = format_sfc_to_antarbhukti(data["sfc_baseline"])

    elif TARGET_EXTRACTION == 'upgraded':
        if "sfc_upgraded" not in data:
            print(f"Error: 'sfc_upgraded' not found in {input_path.name}")
            sys.exit(1)
        output_content = format_sfc_to_antarbhukti(data["sfc_upgraded"])

    elif TARGET_EXTRACTION == 'prompt':
        if "nl_prompt" not in data:
            print(f"Error: 'nl_prompt' not found in {input_path.name}")
            sys.exit(1)
        output_content = data["nl_prompt"]
        
    else:
        print(f"Error: Unknown TARGET_EXTRACTION '{TARGET_EXTRACTION}'. Must be 'baseline', 'upgraded', or 'prompt'.")
        sys.exit(1)

    # Write the formatted output
    with open(output_path, "w") as f:
        f.write(output_content)
    
    print(f"✅ Extracted [{TARGET_EXTRACTION}] to -> {output_path.name}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python extract_triplet.py <input_file.json>")
        sys.exit(1)
    
    in_file = Path(sys.argv[1])
    if not in_file.exists():
        print(f"Error: File '{in_file}' not found.")
        sys.exit(1)
        
    process_file(in_file)