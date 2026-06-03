#!/usr/bin/env python3
"""
fix_raw_llm_files.py  [Fixer #3]
===================================
Some files in train/ and test/ were skipped by uniform_formatter.py because the
JSON inside <SFC_upgraded> tags was malformed (e.g. missing comma before "variables").

This script:
  1. Finds all files that are still raw LLM output (not valid uniform JSON)
  2. Tries to auto-repair common JSON issues using json-repair (if available)
     or a set of targeted regex fixes
  3. Re-runs the uniform_formatter logic to build the final file
  4. Writes the fixed file in-place, or logs failures

Dependencies (optional but recommended):
    pip install json-repair

Run:
    cd DatasetCreation/UpgradesGeneration
    python3 fix_raw_llm_files.py
"""
import json
import re
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Attempt to import json-repair; fall back to manual heuristics if absent
# ---------------------------------------------------------------------------
try:
    from json_repair import repair_json
    HAS_JSON_REPAIR = True
except ImportError:
    HAS_JSON_REPAIR = False
    print("[INFO] json-repair not installed. Using manual heuristic repairs.")
    print("       For better results: pip install json-repair\n")

SCRIPT_DIR   = Path(__file__).resolve().parent        # Dataset_Diagnostics/
UPGEN_DIR    = SCRIPT_DIR.parent                      # UpgradesGeneration/
DATASET_DIR  = UPGEN_DIR / "final_dataset"
ALLSEEDS_DIR = UPGEN_DIR / "ALLSEEDS"
LAYER1_DIR   = UPGEN_DIR / "layer1"

# ---------------------------------------------------------------------------
# JSON repair helpers
# ---------------------------------------------------------------------------

# Common issues the LLM produces:
# 1. Missing comma between a closing ] or } and the next key: ]"key"  ->  ],"key"
# 2. Trailing comma before ] or }
# 3. Single quotes used instead of double quotes (rare)

_MISSING_COMMA_RE = re.compile(r'([}\]])\s*(?=")')   # "}" or "]" immediately followed by "
_TRAILING_COMMA_RE = re.compile(r',\s*([}\]])')       # comma immediately before } or ]


def manual_repair(s: str) -> str:
    """Apply targeted regex fixes for common LLM JSON mistakes."""
    s = _MISSING_COMMA_RE.sub(r'\1,', s)
    s = _TRAILING_COMMA_RE.sub(r'\1', s)
    return s


def try_parse_json(s: str):
    """Try to parse JSON, applying repairs if necessary. Returns parsed object or None."""
    # 1. Direct parse
    try:
        return json.loads(s)
    except json.JSONDecodeError:
        pass

    # 2. Manual heuristic repair
    repaired = manual_repair(s)
    try:
        return json.loads(repaired)
    except json.JSONDecodeError:
        pass

    # 3. json-repair library (more powerful)
    if HAS_JSON_REPAIR:
        try:
            result = repair_json(s, return_objects=True)
            if isinstance(result, dict):
                return result
        except Exception:
            pass

    return None


# ---------------------------------------------------------------------------
# Tag extraction (mirrors uniform_formatter.py)
# ---------------------------------------------------------------------------

def extract_tags(text: str):
    nl_match  = re.search(r'<NL_upgradation_prompt>\s*(.*?)\s*</NL_upgradation_prompt>', text, re.DOTALL)
    sfc_match = re.search(r'<SFC_upgraded>\s*(.*?)\s*</SFC_upgraded>', text, re.DOTALL)

    nl_prompt = nl_match.group(1).strip() if nl_match else None
    sfc_upgraded_str = sfc_match.group(1).strip() if sfc_match else None

    sfc_upgraded = None
    if sfc_upgraded_str:
        sfc_upgraded = try_parse_json(sfc_upgraded_str)

    return nl_prompt, sfc_upgraded


# ---------------------------------------------------------------------------
# Baseline loader (mirrors uniform_formatter.py logic)
# ---------------------------------------------------------------------------

def load_baseline(filename: str):
    """Load the baseline SFC dict for the given dataset filename stem."""
    is_layer_2 = "_L2_" in filename

    if not is_layer_2:
        # Layer 1: baseline is the original OSCAT .txt file
        if "_sfc_iter" in filename:
            seed = filename.split("_sfc_iter")[0]
            base_path = ALLSEEDS_DIR / f"{seed}_sfc.txt"
        else:
            seed = filename.split("_iter")[0]
            base_path = ALLSEEDS_DIR / f"{seed}.txt"

        if base_path.exists():
            try:
                return json.loads(base_path.read_text(encoding="utf-8"))
            except Exception:
                pass
        # Try without suffix
        for p in ALLSEEDS_DIR.glob(f"{seed}*.txt"):
            try:
                return json.loads(p.read_text(encoding="utf-8"))
            except Exception:
                continue
        print(f"  [!] Baseline not found for L1 file: {filename} (tried {base_path})")
        return None

    else:
        # Layer 2: baseline is the already-formatted Layer 1 file
        l1_name = filename.split("_L2_")[0] + ".json"
        l1_path = LAYER1_DIR / l1_name

        if l1_path.exists():
            try:
                content = l1_path.read_text(encoding="utf-8")
                data = json.loads(content)
                # If it's a raw LLM file, extract from tags
                if "sfc_upgraded" in data:
                    return data["sfc_upgraded"]
                # Otherwise extract from generation field
                _, sfc = extract_tags(data.get("generation", ""))
                return sfc
            except Exception:
                # Try tag extraction directly
                try:
                    _, sfc = extract_tags(l1_path.read_text(encoding="utf-8"))
                    return sfc
                except Exception:
                    pass

        # Also try in final_dataset/train (it may already be formatted there)
        for split in ("train", "test"):
            alt = DATASET_DIR / split / l1_name
            if alt.exists():
                try:
                    data = json.loads(alt.read_text(encoding="utf-8"))
                    return data.get("sfc_upgraded")
                except Exception:
                    pass

        print(f"  [!] Baseline not found for L2 file: {filename} (tried {l1_path})")
        return None


# ---------------------------------------------------------------------------
# File processor
# ---------------------------------------------------------------------------

def is_raw_llm_file(path: Path) -> bool:
    """Return True if the file is still raw LLM output (not a valid uniform JSON)."""
    try:
        text = path.read_text(encoding="utf-8").strip()
    except Exception:
        return False
    if not text:
        return False
    try:
        data = json.loads(text)
        # It's JSON — check if it has the uniform schema keys
        return "sfc_baseline" not in data
    except json.JSONDecodeError:
        # Not valid JSON at all — must be raw LLM text
        return True


def process_raw_file(path: Path) -> str:
    """
    Attempt to repair and re-format a raw LLM file.
    Returns: "fixed" | "no_tags" | "bad_json" | "no_baseline" | "skipped"
    """
    try:
        text = path.read_text(encoding="utf-8").strip()
    except Exception:
        return "skipped"

    if not text:
        return "skipped"

    # If it's valid JSON, try to get generation field (Layer 1 format)
    try:
        data = json.loads(text)
        text_to_parse = data.get("generation", text)
    except json.JSONDecodeError:
        text_to_parse = text

    nl_prompt, sfc_upgraded = extract_tags(text_to_parse)

    if not nl_prompt and not sfc_upgraded:
        return "no_tags"
    if not sfc_upgraded:
        return "bad_json"

    sfc_baseline = load_baseline(path.stem)
    if sfc_baseline is None:
        return "no_baseline"

    is_layer_2 = "_L2_" in path.stem
    unified = {
        "id": path.stem,
        "layer": 2 if is_layer_2 else 1,
        "sfc_baseline": sfc_baseline,
        "nl_prompt": nl_prompt or "",
        "sfc_upgraded": sfc_upgraded,
    }

    path.write_text(json.dumps(unified, indent=2), encoding="utf-8")
    return "fixed"


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    counters = {"fixed": 0, "no_tags": 0, "bad_json": 0, "no_baseline": 0,
                "skipped": 0, "already_ok": 0}

    for split in ("train", "test"):
        split_dir = DATASET_DIR / split
        files = sorted(split_dir.glob("*.json"))
        print(f"\nScanning {split}: {len(files)} files...")
        raw_count = 0
        for path in files:
            if not is_raw_llm_file(path):
                counters["already_ok"] += 1
                continue
            raw_count += 1
            result = process_raw_file(path)
            counters[result] += 1
            if result != "fixed":
                print(f"  [{result.upper()}] {path.stem}")
        print(f"  Found {raw_count} raw LLM files.")

    print(f"\n{'='*50}")
    print(f"  Fixed successfully : {counters['fixed']}")
    print(f"  Already OK         : {counters['already_ok']}")
    print(f"  No tags found      : {counters['no_tags']}  (truly broken / empty)")
    print(f"  JSON unrepair able : {counters['bad_json']}  (JSON too mangled)")
    print(f"  Baseline missing   : {counters['no_baseline']}")
    print(f"  Skipped (read err) : {counters['skipped']}")
    print(f"{'='*50}\n")


if __name__ == "__main__":
    main()
