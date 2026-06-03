#!/usr/bin/env python3
"""
fix_from_to.py  [Fixer #1]
==========================
Some dataset files use `from`/`to` keys in transition dicts instead of `src`/`tgt`.
This script renames them in-place across train/ and test/.

Run:
    cd DatasetCreation/UpgradesGeneration
    python3 fix_from_to.py
"""
import json
from pathlib import Path

DATASET_DIR = Path(__file__).resolve().parent.parent / "final_dataset"


def fix_transitions(transitions: list) -> tuple[list, int]:
    """Rename from->src, to->tgt in every transition. Returns (fixed_list, n_fixed)."""
    fixed = 0
    result = []
    for t in transitions:
        if "from" in t and "src" not in t:
            t = {"src": t.pop("from"), "tgt": t.pop("to"), **t}
            fixed += 1
        result.append(t)
    return result, fixed


def process_file(path: Path) -> bool:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError):
        return False  # not a valid uniform JSON, skip (handled by fixer #3)

    total_fixed = 0
    for section in ("sfc_baseline", "sfc_upgraded"):
        sfc = data.get(section)
        if not isinstance(sfc, dict):
            continue
        transitions = sfc.get("transitions", [])
        if not isinstance(transitions, list):
            continue
        fixed, n = fix_transitions(transitions)
        sfc["transitions"] = fixed
        total_fixed += n

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
