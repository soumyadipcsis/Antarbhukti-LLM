import re
import json
import argparse
from pathlib import Path

# --------------------------------------------------
# ST -> SFC extractor (state-machine oriented ST)
# --------------------------------------------------
# Assumptions:
# 1. State machine encoded using: CASE <state_var> OF
# 2. Transitions written as assignments: state := X;
# 3. Guards written using IF <cond> THEN state := X;
# 4. Optional ELSE branches supported
# 5. Numeric state labels (0,1,2,...) or named labels
# --------------------------------------------------


# -----------------------------
# Utility helpers
# -----------------------------

def clean_comments(text: str) -> str:
    """Remove (* ... *) comments"""
    return re.sub(r"\(\*.*?\*\)", "", text, flags=re.DOTALL)


def extract_variables(text: str):
    """Extract variable names from VAR blocks"""
    var_blocks = re.findall(r"VAR.*?END_VAR", text, flags=re.DOTALL | re.IGNORECASE)
    vars_found = set()

    for block in var_blocks:
        for name in re.findall(r"\b([A-Za-z_]\w*)\s*:", block):
            vars_found.add(name)

    return sorted(vars_found)


def extract_state_machine(text: str):
    """Find CASE state OF ... END_CASE"""
    m = re.search(r"CASE\s+(\w+)\s+OF(.*?)END_CASE", text, re.DOTALL | re.IGNORECASE)
    if not m:
        return None, None
    return m.group(1), m.group(2)


def extract_case_blocks(case_body: str):
    """Split individual case labels"""
    pattern = r"([^:\n]+)\s*:\s*(.*?)(?=\n\s*[^:\n]+\s*:|$)"
    matches = re.findall(pattern, case_body, flags=re.DOTALL)
    return [(label.strip(), code.strip()) for label, code in matches]


def parse_transitions(state_var: str, case_blocks):
    """Extract transitions from each state block"""
    transitions = []
    steps = set()

    assign_re = re.compile(rf"{state_var}\s*:=\s*([^;]+);")
    if_re = re.compile(
        rf"IF\s+(.*?)\s+THEN\s+{state_var}\s*:=\s*([^;]+);(?:\s*ELSE\s*{state_var}\s*:=\s*([^;]+);)?",
        re.DOTALL | re.IGNORECASE,
    )

    for src, code in case_blocks:
        steps.add(src)

        # IF guarded transitions
        for cond, tgt_true, tgt_false in if_re.findall(code):
            transitions.append({
                "src": src,
                "tgt": tgt_true.strip(),
                "guard": cond.strip()
            })
            steps.add(tgt_true.strip())

            if tgt_false:
                transitions.append({
                    "src": src,
                    "tgt": tgt_false.strip(),
                    "guard": f"NOT({cond.strip()})"
                })
                steps.add(tgt_false.strip())

        # unconditional transitions
        for tgt in assign_re.findall(code):
            tgt = tgt.strip()
            # skip ones already captured in IF
            if not any(t["src"] == src and t["tgt"] == tgt for t in transitions):
                transitions.append({
                    "src": src,
                    "tgt": tgt,
                    "guard": "TRUE"
                })
                steps.add(tgt)

    return sorted(steps), transitions


def extract_initial_step(text: str, state_var: str):
    """Find initialization: state := X; or state : INT := X;"""
    m = re.search(rf"{state_var}\s*:?=.*?([0-9A-Za-z_]+)", text)
    if m:
        return m.group(1)
    return None


def build_steps(step_names):
    return [{"name": s, "function": f"action_{s}"} for s in step_names]


# -----------------------------
# Main conversion
# -----------------------------

def st_to_sfc(text: str):
    text = clean_comments(text)

    variables = extract_variables(text)
    state_var, case_body = extract_state_machine(text)

    if not state_var:
        return {
            "steps": [],
            "transitions": [],
            "variables": variables,
            "initial_step": None,
        }

    case_blocks = extract_case_blocks(case_body)
    step_names, transitions = parse_transitions(state_var, case_blocks)
    initial = extract_initial_step(text, state_var)

    return {
        "steps": build_steps(step_names),
        "transitions": transitions,
        "variables": variables,
        "initial_step": initial,
    }


# -----------------------------
# CLI
# -----------------------------

def main():
    parser = argparse.ArgumentParser(description="Convert ST state-machine to SFC JSON")
    parser.add_argument("file", help="input ST file")
    parser.add_argument("--out", help="output JSON file", default=None)

    args = parser.parse_args()

    text = Path(args.file).read_text(encoding="utf-8", errors="ignore")
    sfc = st_to_sfc(text)

    if args.out:
        Path(args.out).write_text(json.dumps(sfc, indent=2))
    else:
        print(json.dumps(sfc, indent=2))


if __name__ == "__main__":
    main()
