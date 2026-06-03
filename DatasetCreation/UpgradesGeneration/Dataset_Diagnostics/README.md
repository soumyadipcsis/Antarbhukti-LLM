# Dataset_Diagnostics/

This folder contains all scripts and output files related to **dataset quality checking and repair** for the SFC upgrade dataset (`final_dataset/train` + `final_dataset/test`).

---

## Scripts

Run all scripts from **this folder** (`Dataset_Diagnostics/`). They resolve paths to `final_dataset/` automatically.

### 1. `diagnose_dataset.py` — Categorise issues
Scans every JSON file and puts it in one of these buckets:

| Category | Meaning |
|---|---|
| `OK` | Structurally valid |
| `FROM_TO` | Transitions use `from`/`to` instead of `src`/`tgt` |
| `NUMERIC_STEPS` | Step names are bare numbers (`"7"`, `"42"`) |
| `UNKNOWN_STEP` | A transition references a step name not in the steps list |
| `MISSING_KEYS` | Transitions have neither `src/tgt` nor `from/to` |
| `EMPTY` | File is empty, unreadable, or not valid JSON |

Writes one `.txt` file per non-OK category per split (e.g. `train_from_to_files.txt`).

```bash
python diagnose_dataset.py
```

---

### 2. `fix_from_to.py` — Fixer #1: rename transition keys
Renames `from` → `src` and `to` → `tgt` in every transition dict, in-place.  
Run **before** the other fixers.

```bash
python fix_from_to.py
```

### 3. `fix_numeric_steps.py` — Fixer #2: prefix numeric step names
Renames bare numeric step names (`"7"` → `"Step_7"`) consistently in both the steps list and all transition `src`/`tgt` references.

```bash
python fix_numeric_steps.py
```

### 4. `fix_raw_llm_files.py` — Fixer #3: recover raw LLM outputs
Some files were never converted from the raw LLM output format into the uniform `{sfc_baseline, nl_prompt, sfc_upgraded}` schema. This script finds them, repairs common JSON issues, reconstructs the baseline, and writes the final file in-place. Files it cannot fix are logged.  
Requires `pip install json-repair` for best results.

```bash
python fix_raw_llm_files.py
```

### 5. `verify_dataset.py` — Petri Net containment check
Verifies every `(sfc_baseline, sfc_upgraded)` pair using the `antarbhukti` Verifier. Files where the baseline is **not** contained in the upgrade are logged as invalid.  
Needs the antarbhukti source on `PYTHONPATH`:

```bash
PYTHONPATH=../../../src/antarbhukti python verify_dataset.py
# smoke test (first 10 files per split):
PYTHONPATH=../../../src/antarbhukti python verify_dataset.py --sample 10
```

---

## Recommended run order

```
1. python fix_from_to.py
2. python fix_numeric_steps.py
3. python fix_raw_llm_files.py
4. python diagnose_dataset.py          # check what remains
5. PYTHONPATH=... python verify_dataset.py
```

---

## Output files (generated, safe to re-create)

| File | Source script | Meaning |
|---|---|---|
| `train_from_to_files.txt` | diagnose | Train files with `from`/`to` keys |
| `test_from_to_files.txt` | diagnose | Test files with `from`/`to` keys |
| `train_numeric_steps_files.txt` | diagnose | Train files with numeric step names |
| `test_numeric_steps_files.txt` | diagnose | Test files with numeric step names |
| `train_unknown_step_files.txt` | diagnose | Train files with dangling step refs |
| `test_unknown_step_files.txt` | diagnose | Test files with dangling step refs |
| `train_missing_keys_files.txt` | diagnose | Train files missing transition keys |
| `train_empty_files.txt` | diagnose | Train files that are empty/corrupt |
| `test_empty_files.txt` | diagnose | Test files that are empty/corrupt |
| `train_invalid_files.txt` | verify | Train files failing containment |
| `test_invalid_files.txt` | verify | Test files failing containment |
| `train_errored_files.txt` | verify | Train files that errored during verify |
| `test_errored_files.txt` | verify | Test files that errored during verify |
| `verify_dataset_run.log` | verify | Full log from the last verify run |

> All `.txt` files list one filename stem per line (no path, no `.json`).  
> They are regenerated each run — safe to delete.

---

## Last run results (2026-04-24)

| Category | Train | Test | Total | % |
|---|---|---|---|---|
| **OK** | 25,745 | 2,978 | **28,723** | **87.0%** |
| UNKNOWN_STEP | 1,078 | 171 | 1,249 | 3.8% |
| EMPTY | 2,823 | 211 | 3,034 | 9.2% |
| NUMERIC_STEPS | 1 | 0 | 1 | ~0% |
| MISSING_KEYS | 5 | 0 | 5 | ~0% |
| FROM_TO | 0 | 0 | 0 | ✅ fixed |
