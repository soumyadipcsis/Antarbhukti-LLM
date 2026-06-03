#!/usr/bin/env python3
"""
diagnose_dataset.py
===================
Scans every JSON in final_dataset (train + test) and categorises each file
into one of:
  - EMPTY          : file is empty or not valid JSON
  - FROM_TO        : transitions use 'from'/'to' keys instead of 'src'/'tgt'
  - MISSING_KEYS   : transitions missing both src/tgt AND from/to
  - NUMERIC_STEPS  : step names are numeric strings (e.g. "7")
  - UNKNOWN_STEP   : a transition references a step not in the steps list
  - OK             : structurally valid

Writes per-category lists and prints a summary table.
"""

import json
from pathlib import Path
from collections import defaultdict

SCRIPT_DIR  = Path(__file__).resolve().parent          # Dataset_Diagnostics/
UPGEN_DIR   = SCRIPT_DIR.parent                        # UpgradesGeneration/
DATASET_DIR = UPGEN_DIR / "final_dataset"

SPLITS = ["train", "test"]


def diagnose_file(path: Path) -> tuple[str, str]:
    """Returns (category, detail)."""
    try:
        text = path.read_text(encoding="utf-8").strip()
    except Exception as e:
        return "EMPTY", str(e)

    if not text:
        return "EMPTY", "file is empty"

    try:
        data = json.loads(text)
    except json.JSONDecodeError as e:
        return "EMPTY", f"JSON parse error: {e}"

    issues = []
    for section in ("sfc_baseline", "sfc_upgraded"):
        sfc = data.get(section) or {}
        if not sfc:
            issues.append(("EMPTY", f"{section} is null/missing"))
            continue
        steps = sfc.get("steps", []) or []
        transitions = sfc.get("transitions", [])
        step_names = {s["name"] for s in steps if "name" in s}

        # Check for numeric step names in the steps list
        if any(s.get("name", "").isdigit() for s in steps):
            issues.append(("NUMERIC_STEPS", section))

        for t in transitions:
            has_src_tgt  = "src" in t and "tgt" in t
            has_from_to  = "from" in t and "to" in t

            if has_from_to and not has_src_tgt:
                issues.append(("FROM_TO", section))
                break
            elif not has_src_tgt and not has_from_to:
                issues.append(("MISSING_KEYS", section))
                break
            elif has_src_tgt:
                # Check that referenced steps exist
                if t["src"] not in step_names or t["tgt"] not in step_names:
                    issues.append(("UNKNOWN_STEP", f"{section} tgt={t.get('tgt')} src={t.get('src')}"))
                    break

    if not issues:
        return "OK", ""

    # Return the highest-priority issue
    priority = ["EMPTY", "FROM_TO", "MISSING_KEYS", "NUMERIC_STEPS", "UNKNOWN_STEP"]
    for cat in priority:
        for issue_cat, detail in issues:
            if issue_cat == cat:
                return cat, detail
    return issues[0]


def main():
    counts   = defaultdict(int)        # category -> count
    per_split = defaultdict(lambda: defaultdict(list))  # split -> category -> [names]

    for split in SPLITS:
        split_dir = DATASET_DIR / split
        files = sorted(split_dir.glob("*.json"))
        total = len(files)
        print(f"Scanning {split}: {total} files ...", flush=True)

        for path in files:
            cat, detail = diagnose_file(path)
            counts[cat] += 1
            per_split[split][cat].append(path.stem)

    # --- Write per-split category files ---
    for split in SPLITS:
        for cat, names in per_split[split].items():
            out = SCRIPT_DIR / f"{split}_{cat.lower()}_files.txt"  # written into Dataset_Diagnostics/
            out.write_text(f"# {split} files with issue: {cat}\n" +
                           "\n".join(names) + "\n")
            print(f"  Written: {out}  ({len(names)} entries)")

    # --- Summary table ---
    all_cats = ["OK", "FROM_TO", "UNKNOWN_STEP", "NUMERIC_STEPS", "MISSING_KEYS", "EMPTY"]
    total_all = sum(counts.values())

    print(f"\n{'='*58}")
    print(f"{'Category':<20} {'Train':>8} {'Test':>8} {'Total':>8} {'%':>6}")
    print(f"{'-'*58}")
    for cat in all_cats:
        tr = len(per_split["train"][cat])
        te = len(per_split["test"][cat])
        tot = tr + te
        pct = 100*tot/total_all if total_all else 0
        print(f"{cat:<20} {tr:>8} {te:>8} {tot:>8} {pct:>5.1f}%")
    print(f"{'-'*58}")
    print(f"{'TOTAL':<20} {sum(len(per_split['train'][c]) for c in all_cats):>8} "
          f"{sum(len(per_split['test'][c]) for c in all_cats):>8} {total_all:>8}")
    print(f"{'='*58}\n")


if __name__ == "__main__":
    main()
