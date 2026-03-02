import streamlit as st
import re
import json


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

def extract_state_machines(text: str):
    """Find all CASE state OF ... END_CASE blocks"""
    matches = re.findall(r"CASE\s+(\w+)\s+OF(.*?)END_CASE", text, re.DOTALL | re.IGNORECASE)
    return [(m[0], m[1]) for m in matches]

def extract_case_blocks(case_body: str):
    """Split individual case labels"""
    pattern = r"([^:\n]+)\s*:\s*(.*?)(?=\n\s*[^:\n]+\s*:|$)"
    matches = re.findall(pattern, case_body, flags=re.DOTALL)
    return [(label.strip(), code.strip()) for label, code in matches]


# def parse_transitions(state_var: str, case_blocks):
#     """Extract transitions for the state variable only"""
#     transitions = []
#     steps = set()

#     # Match assignments to the state variable
#     assign_re = re.compile(rf"{state_var}\s*:=\s*([0-9A-Za-z_+\-]+);")

#     # Match IF guarded transitions
#     if_re = re.compile(
#         rf"IF\s+(.*?)\s+THEN.*?{state_var}\s*:=\s*([^;]+);(?:.*?ELSE.*?{state_var}\s*:=\s*([^;]+);)?",
#         re.DOTALL | re.IGNORECASE,
#     )

#     for src, code in case_blocks:
#         steps.add(src)

#         # Guarded transitions
#         for cond, tgt_true, tgt_false in if_re.findall(code):
#             transitions.append({"src": src, "tgt": tgt_true.strip(), "guard": cond.strip()})
#             steps.add(tgt_true.strip())
#             if tgt_false:
#                 transitions.append({"src": src, "tgt": tgt_false.strip(), "guard": f"NOT({cond.strip()})"})
#                 steps.add(tgt_false.strip())

#         # Unconditional transitions (direct assignments to state_var)
#         for tgt in assign_re.findall(code):
#             tgt = tgt.strip()
#             transitions.append({"src": src, "tgt": tgt, "guard": "TRUE"})
#             steps.add(tgt)

#     return sorted(steps), transitions

# def parse_transitions(state_var: str, case_blocks):
#     transitions = []
#     steps = set()

#     # Only match assignments to the state variable
#     assign_re = re.compile(rf"{state_var}\s*:=\s*([0-9]+);")

#     # Match IF guarded transitions
#     if_re = re.compile(
#         rf"IF\s+(.*?)\s+THEN.*?{state_var}\s*:=\s*([0-9]+);",
#         re.DOTALL | re.IGNORECASE,
#     )

#     for src, code in case_blocks:
#         steps.add(src)

#         # Guarded transitions
#         for cond, tgt_true in if_re.findall(code):
#             transitions.append({"src": src, "tgt": tgt_true.strip(), "guard": cond.strip()})
#             steps.add(tgt_true.strip())

#         # Unconditional transitions
#         for tgt in assign_re.findall(code):
#             transitions.append({"src": src, "tgt": tgt.strip(), "guard": "TRUE"})
#             steps.add(tgt.strip())

#     return sorted(steps), transitions
# def parse_transitions(state_var: str, case_blocks):
#     transitions = []
#     steps = set()

#     # Only match assignments to the state variable (numbers only)
#     assign_re = re.compile(rf"{state_var}\s*:=\s*(\d+);")

#     # Match IF guarded transitions
#     if_re = re.compile(
#         rf"IF\s+(.*?)\s+THEN\s+.*?{state_var}\s*:=\s*(\d+);",
#         re.DOTALL | re.IGNORECASE,
#     )

#     for src, code in case_blocks:
#         steps.add(src)

#         # Guarded transitions
#         for cond, tgt_true in if_re.findall(code):
#             transitions.append({"src": src, "tgt": tgt_true.strip(), "guard": cond.strip()})
#             steps.add(tgt_true.strip())

#         # Unconditional transitions
#         for tgt in assign_re.findall(code):
#             transitions.append({"src": src, "tgt": tgt.strip(), "guard": "TRUE"})
#             steps.add(tgt.strip())

#     return sorted(steps), transitions
# def parse_transitions(state_var: str, case_blocks):
#     transitions = []
#     steps = set()

#     for src, code in case_blocks:
#         steps.add(src)
#         lines = code.splitlines()
#         current_guard = None

#         for line in lines:
#             line = line.strip()

#             # Track IF conditions
#             if line.upper().startswith("IF ") and "THEN" in line.upper():
#                 cond = line[3:line.upper().find("THEN")].strip()
#                 current_guard = cond

#             # Reset guard at END_IF
#             if line.upper().startswith("END_IF"):
#                 current_guard = None

#             # Look for LightState assignments
#             m = re.search(rf"{state_var}\s*:=\s*(\d+);", line)
#             if m:
#                 tgt = m.group(1)
#                 guard = current_guard if current_guard else "TRUE"
#                 transitions.append({"src": src, "tgt": tgt, "guard": guard})
#                 steps.add(tgt)

#     return sorted(steps), transitions



def extract_initial_step(text: str, state_var: str):
    """Find initialization: state := X; or state : INT := X;"""
    m = re.search(rf"{state_var}\s*:?=.*?([0-9A-Za-z_]+)", text)
    if m:
        return m.group(1)
    return None

def build_steps(step_names):
    return [{"name": s, "function": f"action_{s}"} for s in step_names]

# --- your corrected parser goes here --- 
def parse_transitions(state_var: str, case_blocks): 
    transitions = [] 
    steps = set() 
    for src, code in case_blocks: 
        steps.add(src) 
        lines = code.splitlines() 
        current_guard = None for line in lines: 
            line = line.strip() # Track IF conditions 
            if line.upper().startswith("IF ") and "THEN" in line.upper(): 
                cond = line[3:line.upper().find("THEN")].strip() 
                current_guard = cond # Reset guard at END_IF 
                if line.upper().startswith("END_IF"): 
                    current_guard = None # Look for LightState assignments 
                    m = re.search(rf"{state_var}\s*:=\s*(\d+);", line) 
                    if m: 
                        tgt = m.group(1) 
                        guard = current_guard if current_guard else "TRUE" 
                        transitions.append({"src": src, "tgt": tgt, "guard": guard}) 
                        steps.add(tgt) 
    return sorted(steps), transitions

def st_to_sfc(text: str):
    text = clean_comments(text)
    variables = extract_variables(text)
    machines = extract_state_machines(text)

    all_steps = []
    all_transitions = []
    initial_steps = {}

    if machines:
        for state_var, case_body in machines:
            case_blocks = extract_case_blocks(case_body)
            step_names, transitions = parse_transitions(state_var, case_blocks)
            initial = extract_initial_step(text, state_var)
            all_steps.extend(step_names)
            all_transitions.extend(transitions)
            initial_steps[state_var] = initial

    return {
        "steps": build_steps(sorted(set(all_steps))),
        "transitions": all_transitions,
        "variables": variables,
        "initial_step": initial_steps,
    }


# def visualize_sfc(sfc): 
#     """Generate Graphviz diagram from SFC transitions""" 
#     dot = graphviz.Digraph() 
#     for step in sfc["steps"]: 
#         dot.node(step["name"], 
#                  step["name"]) 
#         for t in sfc["transitions"]: 
#             label = t["guard"] 
#             dot.edge(t["src"], t["tgt"], label=label) 
#             return dot

# -----------------------------
# Streamlit UI
# -----------------------------

st.title("⚙️ ST → SFC Analyzer (State Variable Focused)")
# uploaded_file = st.file_uploader("Upload a Structured Text (.st) file", type=["st", "txt"])%#

uploaded_file = st.file_uploader("Upload a Structured Text (.st) file", type=["st", "txt"])

if uploaded_file:
    text = uploaded_file.read().decode("utf-8", errors="ignore")
    sfc = st_to_sfc(text)

    st.subheader("Extracted JSON")
    st.json(sfc)

    st.subheader("Steps")
    st.table(sfc["steps"])

    st.subheader("Transitions")
    st.table(sfc["transitions"])

    st.subheader("Variables")
    st.write(", ".join(sfc["variables"]) if sfc["variables"] else "None")

    st.subheader("Initial Steps")
    st.json(sfc["initial_step"])
    st.subheader("State Machine Diagram") 
    # dot = visualize_sfc(sfc) st.graphviz_chart(dot)