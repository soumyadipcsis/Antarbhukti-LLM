"""
batch_st_to_sfc.py
==================
Batch-processes all files in a source folder through st_to_sfc_parser,
writing the resulting SFC representations to a sibling folder named
<sourcefolder>SFCs/.

Usage
-----
    python batch_st_to_sfc.py <source_folder>

Example
-------
    python batch_st_to_sfc.py batch1_filtered_BASIC
    # -> creates batch1_filtered_BASICSFCs/ with one *_sfc.txt per input file
"""

import json
import os
import sys

from st_to_sfc_parser import parse_st_to_sfc

# --- Terminal Colors ---
OK_GREEN = '\033[92m'
WARN_YELLOW = '\033[93m'
RESET = '\033[0m'
# -----------------------

def batch_parse(source_folder: str) -> None:
    # Normalise: strip any trailing path separator
    source_folder = source_folder.rstrip(os.sep).rstrip('/')

    if not os.path.isdir(source_folder):
        print(f"Error: '{source_folder}' is not a directory.")
        sys.exit(1)

    output_folder = source_folder + 'SFCs'
    os.makedirs(output_folder, exist_ok=True)
    print(f"Output folder: {output_folder}\n")

    files = [f for f in os.listdir(source_folder)
             if os.path.isfile(os.path.join(source_folder, f))]

    ok = 0
    errors = 0

    for filename in sorted(files):
        input_path = os.path.join(source_folder, filename)
        stem, _ = os.path.splitext(filename)
        output_path = os.path.join(output_folder, f"{stem}_sfc.txt")

        result = parse_st_to_sfc(input_path)

        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(result, f, indent=2)

        # Print with colors!
        if 'error' in result:
            print(f"  {WARN_YELLOW}[WARN]{RESET} {filename} -> {result['error']}")
            errors += 1
        else:
            print(f"  {OK_GREEN}[OK]{RESET}   {filename} -> {os.path.basename(output_path)}")
            ok += 1

    print(f"\nDone. Processed {len(files)} file(s): {ok} ok, {errors} with errors/warnings.")
    print(f"Results saved to: {os.path.abspath(output_folder)}")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python batch_st_to_sfc.py <source_folder>")
        sys.exit(1)

    batch_parse(sys.argv[1])