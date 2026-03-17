import streamlit as st
import re
import json
#import graphviz

# --- helper functions ---
def clean_comments(text: str):
    return re.sub(r"\(\*.*?\*\)", "", text, flags=re.DOTALL)

def extract_variables(text: str):
    var_blocks = re.findall(r"VAR.*?END_VAR", text, flags=re.DOTALL | re.IGNORECASE)
    vars_found = set()
    for block in var_blocks:
        for name in re.findall(r"\b([A-Za-z_]\w*)\s*:", block):
            vars_found.add(name)
    return sorted(vars_found)

def extract_state_machines(text: str):
    matches = re.findall(r"CASE\s+(\w+)\s+OF(.*?)END_CASE", text, re.DOTALL | re.IGNORECASE)
    return [(m[0], m[1]) for m in matches]

def extract_case_blocks(case_body: str):
    # Improved pattern to handle various case label formats
    pattern = r"(\w+)\s*:\s*(.*?)(?=\n\s*\w+\s*:|$)"
    matches = re.findall(pattern, case_body, flags=re.DOTALL)
    return [(label.strip(), code.strip()) for label, code in matches]

def extract_initial_step(text: str, state_var: str):
    # Case-insensitive search for initial value
    m = re.search(rf"{re.escape(state_var)}\s*:?=\s*(\w+)", text, re.IGNORECASE)
    if m:
        return m.group(1)
    return None

def build_steps(step_names):
    return [{"name": s, "function": f"action_{s}"} for s in step_names]

# --- CORRECTED parser ---
def parse_transitions(state_var: str, case_blocks):
    transitions = []
    steps = set()

    for src, code in case_blocks:
        steps.add(src)
        lines = code.splitlines()
        current_guard = None
        in_if_block = False

        for line in lines:
            line_stripped = line.strip()

            # Track IF conditions (improved)
            if re.match(r"IF\s+", line_stripped, re.IGNORECASE):
                # Extract condition between IF and THEN
                m = re.search(r"IF\s+(.*?)\s+THEN", line_stripped, re.IGNORECASE)
                if m:
                    current_guard = m.group(1).strip()
                    in_if_block = True
                else:
                    # Handle multi-line IF
                    m = re.search(r"IF\s+(.*?)$", line_stripped, re.IGNORECASE)
                    if m:
                        current_guard = m.group(1).strip()
                        in_if_block = True

            # Track ELSIF conditions
            elif re.match(r"ELSIF\s+", line_stripped, re.IGNORECASE):
                m = re.search(r"ELSIF\s+(.*?)\s+THEN", line_stripped, re.IGNORECASE)
                if m:
                    current_guard = m.group(1).strip()

            # Reset guard at END_IF
            elif re.match(r"END_IF", line_stripped, re.IGNORECASE):
                current_guard = None
                in_if_block = False

            # Look for state variable assignments (IMPROVED)
            # Allow for:
            # - Optional semicolon
            # - Case-insensitive variable name
            # - Both numeric and named constants
            # - Optional spaces
            assignment_patterns = [
                rf"{re.escape(state_var)}\s*:=\s*(\w+)",  # Word (constant or number)
                rf"{re.escape(state_var)}\s*:=\s*(\d+)",   # Just digits
            ]
            
            for pattern in assignment_patterns:
                m = re.search(pattern, line_stripped, re.IGNORECASE)
                if m:
                    tgt = m.group(1)
                    guard = current_guard if current_guard else "TRUE"
                    transitions.append({
                        "src": src, 
                        "tgt": tgt, 
                        "guard": guard
                    })
                    steps.add(tgt)
                    break  # Found a match, no need to try other patterns

    return sorted(steps), transitions

# --- orchestrator ---
def st_to_sfc(text: str):
    text = clean_comments(text)
    variables = extract_variables(text)
    machines = extract_state_machines(text)

    all_steps = []
    all_transitions = []
    initial_steps = {}

    if machines:
        st.write(f"Found {len(machines)} state machine(s)")  # Debug info
        for state_var, case_body in machines:
            st.write(f"Processing state variable: {state_var}")  # Debug info
            case_blocks = extract_case_blocks(case_body)
            st.write(f"Found {len(case_blocks)} case blocks")  # Debug info
            step_names, transitions = parse_transitions(state_var, case_blocks)
            initial = extract_initial_step(text, state_var)
            all_steps.extend(step_names)
            all_transitions.extend(transitions)
            initial_steps[state_var] = initial
            st.write(f"Found {len(transitions)} transitions")  # Debug info

    return {
        "steps": build_steps(sorted(set(all_steps))),
        "transitions": all_transitions,
        "variables": variables,
        "initial_step": initial_steps,
    }

# --- visualization ---
# def visualize_sfc(sfc):
#     dot = graphviz.Digraph()
#     for step in sfc["steps"]:
#         dot.node(step["name"], step["name"])
#     for t in sfc["transitions"]:
#         dot.edge(t["src"], t["tgt"], label=t["guard"])
#     return dot

# --- Streamlit UI ---
st.title("⚙️ ST → SFC Analyzer with Visualization")

uploaded_file = st.file_uploader("Upload a Structured Text (.st) file", type=["st", "txt"])

if uploaded_file:
    text = uploaded_file.read().decode("utf-8", errors="ignore")
    
    # Show raw text for debugging
    with st.expander("View Raw Text"):
        st.text(text[:1000] + "..." if len(text) > 1000 else text)
    
    sfc = st_to_sfc(text)

    st.subheader("📊 Extracted JSON")
    st.json(sfc)

    st.subheader("📋 Steps")
    if sfc["steps"]:
        st.table(sfc["steps"])
    else:
        st.warning("No steps found")

    st.subheader("🔄 Transitions")
    if sfc["transitions"]:
        st.table(sfc["transitions"])
    else:
        st.error("No transitions found - Check if state assignments match the pattern: 'StateVar := value'")

    # st.subheader("State Machine Diagram")
    # dot = visualize_sfc(sfc)
    # st.graphviz_chart(dot)
