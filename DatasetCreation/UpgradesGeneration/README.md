# Antarbhukti: SFC Upgrades Generation & Evaluation Pipeline

## Overview
This repository contains the data engineering, generation, and verification pipeline.
The primary goal of this pipeline is to generate, and clean a large-scale dataset of IEC 61131-3 Sequential Function Chart (SFC) upgrades. 

This dataset maps baseline SFC factory logic to natural language safety/reliability prompts and outputs the safely upgraded SFC JSON. 

> **Note:** The actual dataset files (`.json`) are excluded from this repository.

---

## Directory Structure

```text
UpgradesGeneration/
├── ALLSEEDS/                # Contains the original, unmodified OSCAT baseline SFCs
├── layer1/                  # Stores Layer 1 generations (Single safety upgrade)
├── layer2/                  # Stores Layer 2 generations (Compositional/Multi-rule upgrades)
├── final_dataset/           # The processed, uniform train/test splits ready for SFT
├── Dataset_Diagnostics/     # Scripts for mathematical verification and syntax sanitization
│   ├── verify_dataset.py    # Strict Antarbhukti Petri-Net containment verifier
│   └── zero_shot_eval.py    # Multi-model API testing harness
├── PromptForUpgrades.txt    # The strict System Prompt & Upgrade Library ruleset
└── [Pipeline Scripts]       # Python automation files (see Pipeline Phases below)

```


---

## Pipeline Phases & Script Documentation

The pipeline is sequentially designed to handle generation, sanitation, splitting, and verification.

### Phase 1: Generation Pipeline

Scripts used to query LLMs (DeepSeek, Claude) to apply safety and reliability upgrades to the baseline OSCAT seeds.

* **`deepseek_multithread.py`**: A high-concurrency script to hit the DeepSeek API, generating thousands of upgraded SFCs while managing rate limits and parsing strict XML/JSON outputs.
* **`create_layer2_batch.py`**: Iterates over successful Layer 1 generations and applies a *second* distinct safety rule, creating complex, compositional logic upgrades.
* **`CLAUDE_run_batch.py` & `CLAUDE_create_batch.py**`: Equivalent batch-processing scripts optimized for the Anthropic Claude API architecture.
* **`rescue_batch.py`**: A utility script to sweep for corrupted or truncated API responses and re-queue them for generation.

### Phase 2: Data Sanitation & Triplet Formatting

Raw LLM outputs often contain markdown hallucinations or missing tags. These scripts enforce strict dataset uniformity.

* **`layer1_cleaner.py`**: Acts as a quarantine bouncer. Sweeps the generation folders and evicts any files that failed to generate valid JSON or hit token limit cutoffs mid-generation.
* **`uniform_formatter.py`**: The core dataset compiler. It extracts the raw baseline, the `<NL_upgradation_prompt>`, and the `<SFC_upgraded>`, stitching them together into a unified `{"sfc_baseline": {}, "nl_prompt": "", "sfc_upgraded": {}}` triplet format required for standard SFT.

### Phase 3: Mathematical Isolation (Data Splitting)

* **`train_test_split.py`**: Enforces a strict 90/10 split of the dataset. Critically, it splits the data based on the **original `ALLSEEDS` root file**, preventing "data leakage" (e.g., ensuring a Layer 2 file does not end up in the test set if its parent Layer 1 file is in the training set).

### Phase 4: Diagnostic Fixing & Syntax Correction

Located in `Dataset_Diagnostics/`, these scripts fix minor LLM schema hallucinations without discarding logically valid data.

* **`fix_from_to.py`**: Normalizes schema errors where the LLM hallucinated `{"from": X, "to": Y}` instead of the strict IEC 61131-3 `{"src": X, "tgt": Y}` specification.
* **`fix_numeric_steps.py`**: Resolves strict naming violations (e.g., converting invalid numerical step names like `"7"` to `"Step_7"`).
* **`diagnose_dataset.py`**: Sweeps the formatted dataset to flag dangling references, empty guards, or structurally corrupted graphs.

### Phase 5: Verification & Zero-Shot Evaluation

The final gateway before machine learning training begins.

* **`verify_dataset.py`**: Integrates with the core Antarbhukti Petri-Net engine. Mathematically checks if the upgraded SFC logic safely *contains* the baseline logic without destructively overwriting existing factory operations.
* **`zero_shot_eval.py`**: An automated inference harness designed to test local models (e.g., Qwen 2.5 7B, Llama 3.1 8B, Mistral NeMo) out-of-the-box via API. It calculates Precision/Recall metrics for step and transition creation and grades overall logic alignment.

---

## Data Schema Format

When the pipeline finishes, every file in `final_dataset/` strictly adheres to this triplet schema:

```json
{
  "id": "SEED_NAME_sfc_iter_XX",
  "layer": 1,
  "sfc_baseline": {
    "steps": [...],
    "transitions": [...],
    "variables": [...],
    "initial_step": "..."
  },
  "nl_prompt": "When: [Condition]\nAction: [Structural Change]",
  "sfc_upgraded": {
    "steps": [...],
    "transitions": [...],
    "variables": [...],
    "initial_step": "..."
  }
}

```