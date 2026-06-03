#!/usr/bin/env python3
"""
verify_dataset.py
=================
Verify the soundness of every (sfc_baseline, sfc_upgraded) pair in a
dataset directory by checking that sfc_baseline is *contained* in sfc_upgraded
via Petri Net path-equivalence (re-using the existing antarbhukti Verifier).

Usage:
    cd DatasetCreation/UpgradesGeneration/Dataset_Diagnostics
    PYTHONPATH=../../../src/antarbhukti python verify_dataset.py [--sample N] [--dataset-dir PATH]

Defaults to filtered_final_dataset/ if it exists, otherwise final_dataset/.

Outputs (written next to this script):
    train_invalid_files.txt  - train filenames that FAIL containment
    test_invalid_files.txt   - test filenames that FAIL containment
    train_errored_files.txt  - train filenames that ERROR'd during check
    test_errored_files.txt   - test filenames that ERROR'd during check
"""

import argparse
import json
import os
import sys
import traceback
from pathlib import Path

# ---------------------------------------------------------------------------
# Locate the src/antarbhukti directory and add it to PYTHONPATH if needed
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent.parent
SRC_DIR = REPO_ROOT / "src" / "antarbhukti"

if str(SRC_DIR) not in sys.path:
    sys.path.insert(0, str(SRC_DIR))

try:
    from sfc import SFC
    from sfc_verifier import Verifier
except ImportError as e:
    print(f"[ERROR] Could not import antarbhukti modules: {e}")
    print(f"  Make sure {SRC_DIR} is on PYTHONPATH, or run:")
    print(f"  PYTHONPATH={SRC_DIR} python verify_dataset.py")
    sys.exit(1)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def sfc_from_dict(d: dict) -> SFC:
    """
    Create a SFC object from a dict (as stored in the JSON dataset).
    Bypasses SFC.load() which expects a text file.
    """
    sfc = SFC()
    sfc.steps = d.get("steps", [])
    sfc.transitions = d.get("transitions", [])
    sfc.variables = d.get("variables", [])
    sfc.initial_step = d.get("initial_step", "")
    sfc.filename = "<from_dict>"
    return sfc


def check_file(json_path: Path):
    """
    Returns:
        "ok"      - baseline is contained in upgraded
        "invalid" - baseline is NOT contained in upgraded
        "error"   - an exception occurred; tb string returned in second value

    Returns (status: str, detail: str)
    """
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        sfc_base = sfc_from_dict(data["sfc_baseline"])
        sfc_upg  = sfc_from_dict(data["sfc_upgraded"])

        pn_base = sfc_base.to_pn()
        pn_upg  = sfc_upg.to_pn()

        verifier = Verifier()
        contained = verifier.check_pn_containment(sfc_base, pn_base, sfc_upg, pn_upg)

        if contained:
            return "ok", ""
        else:
            unmatched = verifier.get_unmatched_paths()
            detail = f"{len(unmatched)} unmatched path(s)"
            return "invalid", detail

    except Exception:
        tb = traceback.format_exc()
        return "error", tb


def verify_split(split_dir: Path, split_name: str, sample: int = 0):
    """
    Run verification on all JSON files in split_dir.
    Returns (invalid_names, errored_names) lists.
    """
    all_files = sorted(split_dir.glob("*.json"))
    if sample > 0:
        all_files = all_files[:sample]

    total = len(all_files)
    invalid_names = []
    errored_names = []

    print(f"\n{'='*60}")
    print(f"  Split: {split_name}  |  Files to check: {total}")
    print(f"{'='*60}")

    ok_count = 0
    for i, path in enumerate(all_files, 1):
        name = path.stem   # filename without .json
        status, detail = check_file(path)

        if status == "ok":
            ok_count += 1
            tag = "OK"
        elif status == "invalid":
            invalid_names.append(name)
            tag = f"INVALID ({detail})"
        else:
            errored_names.append(name)
            # Print first line of traceback only to keep output clean
            first_line = detail.strip().splitlines()[-1]
            tag = f"ERROR  ({first_line[:80]})"

        # Progress line (overwrite in terminal)
        prefix = f"[{i:>5}/{total}]"
        print(f"{prefix}  {tag:<50}  {name}", flush=True)

    print(f"\n--- {split_name} summary ---")
    print(f"  OK      : {ok_count}")
    print(f"  INVALID : {len(invalid_names)}")
    print(f"  ERROR   : {len(errored_names)}")

    return invalid_names, errored_names


def write_list(path: Path, names: list, header: str):
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"# {header}\n")
        for n in names:
            f.write(n + "\n")
    print(f"  Written: {path}  ({len(names)} entries)")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Verify dataset upgrade soundness.")
    parser.add_argument(
        "--sample", type=int, default=0,
        help="Only check the first N files per split (0 = all, useful for smoke tests)"
    )
    parser.add_argument(
        "--dataset-dir", type=str, default=None,
        help="Path to dataset directory containing train/ and test/ splits. "
             "Defaults to filtered_final_dataset/ if it exists, else final_dataset/."
    )
    args = parser.parse_args()

    upgen_dir = SCRIPT_DIR.parent
    if args.dataset_dir:
        dataset_dir = Path(args.dataset_dir).resolve()
    elif (upgen_dir / "filtered_final_dataset").exists():
        dataset_dir = upgen_dir / "filtered_final_dataset"
    else:
        dataset_dir = upgen_dir / "final_dataset"

    print(f"Dataset dir : {dataset_dir}")
    if not dataset_dir.exists():
        print(f"[ERROR] Dataset directory not found: {dataset_dir}")
        sys.exit(1)

    train_dir = dataset_dir / "train"
    test_dir  = dataset_dir / "test"

    # ---- Train ----
    train_invalid, train_errored = verify_split(train_dir, "TRAIN", sample=args.sample)
    write_list(SCRIPT_DIR / "train_invalid_files.txt",
               train_invalid, "Train files failing containment check")
    write_list(SCRIPT_DIR / "train_errored_files.txt",
               train_errored, "Train files that errored during check")

    # ---- Test ----
    test_invalid, test_errored = verify_split(test_dir, "TEST", sample=args.sample)
    write_list(SCRIPT_DIR / "test_invalid_files.txt",
               test_invalid, "Test files failing containment check")
    write_list(SCRIPT_DIR / "test_errored_files.txt",
               test_errored, "Test files that errored during check")

    # ---- Grand summary ----
    total_invalid = len(train_invalid) + len(test_invalid)
    total_errored = len(train_errored) + len(test_errored)
    total_files   = (
        len(list(train_dir.glob("*.json"))) +
        len(list(test_dir.glob("*.json")))
    )
    if args.sample > 0:
        total_files = min(total_files, args.sample * 2)

    print(f"\n{'='*60}")
    print(f"  GRAND TOTAL")
    print(f"  Files checked : {total_files}")
    print(f"  INVALID       : {total_invalid}")
    print(f"  ERRORED       : {total_errored}")
    print(f"  OK            : {total_files - total_invalid - total_errored}")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    main()
