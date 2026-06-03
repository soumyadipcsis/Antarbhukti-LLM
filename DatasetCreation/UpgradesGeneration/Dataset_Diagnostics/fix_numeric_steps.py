#!/usr/bin/env python3
"""
fix_numeric_steps.py  [Fixer #2]
=================================
Some SFCs (inherited from original OSCAT XML) have numeric step names like "7", "178".
This script prefixes them with "Step_" (e.g. "7" -> "Step_7") consistently in both
the steps list and all transition src/tgt references.

Run:
    cd DatasetCreation/UpgradesGeneration
    python3 fix_numeric_steps.py
"""
import json
from pathlib import Path

DATASET_DIR = Path(__file__).resolve().parent.parent / "final_dataset"


def is_numeric_name(name: str) -> bool:
    return isinstance(name, str) and name.isdigit()


def prefix(name: str) -> str:
    return f"Step_{name}" if is_numeric_name(name) else name


def fix_sfc(sfc: dict) -> int:
    """Fix numeric step names in steps list and transitions. Returns count of names fixed."""
    count = 0

    steps = sfc.get("steps", []) or []
    for step in steps:
        if is_numeric_name(step.get("name", "")):
            step["name"] = prefix(step["name"])
            count += 1

    transitions = sfc.get("transitions", []) or []
    for t in transitions:
        for key in ("src", "tgt"):
            if is_numeric_name(t.get(key, "")):
                t[key] = prefix(t[key])
                count += 1

    return count


def process_file(path: Path) -> bool:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError):
        return False  # skip non-uniform JSON (will be handled by fixer #3)

    total_fixed = 0
    for section in ("sfc_baseline", "sfc_upgraded"):
        sfc = data.get(section)
        if isinstance(sfc, dict):
            total_fixed += fix_sfc(sfc)

    if total_fixed > 0:
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")
    return total_fixed > 0


def main():
    total_files = fixed_files = 0
    for split in ("train", "test"):
        split_dir = DATASET_DIR / split
        files = sorted(split_dir.glob("*.json"))
        print(f"\nScanning {split}: {len(files)} files...")
        for path in files:
            total_files += 1
            if process_file(path):
                fixed_files += 1

    print(f"\nDone. Fixed {fixed_files} / {total_files} files.")


if __name__ == "__main__":
    main()
