#!/usr/bin/env python3
"""
Antarbhukti — Enterprise Verification Platform
UI/UX Updated: Dashboard-First, Metrics-Driven, Sales-Ready.
Fixed: Dashboard fits on one screen (compact layout).
Fixed: Strips Markdown (```python) from LLM output in Upgrade Designer.
Feature: Upgrade Designer (Direct GPT-4o Integration) with Multi-Select UI Demo Mode.
Feature: Auto-detection and conversion of OpenPLC XML/ST files using xmltotxt.py.
Feature: Downloadable Intermediate SFC1 file (for Workstation pairing).
Feature: "Eventual Success" Tracking (High Success Rate Logic).
"""

import streamlit as st
import os
import sys
import subprocess
import datetime
import shutil
import re
import glob
import time
import unicodedata
import json
import pandas as pd
import altair as alt
import streamlit.components.v1 as components
#import pkg_resources
import setuptools
import z3

st.write("Python executable:", sys.executable)
st.write("Python version:", sys.version)
st.write("setuptools version:", setuptools.__version__)
st.write("pkg_resources OK")
st.write("z3 version:", z3.get_version_string())
# --- PATH SETUP: Ensure we can find src ---
current_dir = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.join(current_dir, "src")
if src_path not in sys.path:
    sys.path.append(src_path)

# ---------------------------
# Config & Page Setup
# ---------------------------
st.set_page_config(page_title="LLMA Tool", page_icon="⚡", layout="wide")

# --- HOSTING FIX: Reconstruct config.json from Secrets ---
def ensure_config_exists():
    config_dir = os.path.join(current_dir, "src", "antarbhukti")
    config_path = os.path.join(config_dir, "config.json")
    
    # Only recreate if file is missing AND we have secrets (Cloud Environment)
    if not os.path.exists(config_path) and "llm_credentials" in st.secrets:
        secrets = st.secrets["llm_credentials"]
        
        # Exact structure based on your provided JSON
        config_data = [
            {
                "llm_name": "gpt4o",
                "model_name": "gpt-4o",
                "api_key": secrets.get("gpt4o_key", ""),
                "max_tokens": 1500,
                "max_retries": 5,
                "temperature": 0.3,
                "top_p": 0.9,
                "top_k": 10,
                "n": 1,
                "stop": None
            },
            {
                "llm_name": "gemini",
                "model_name": "gemini-2.5-flash",
                "api_key": secrets.get("gemini_key", ""),
                "max_tokens": 1500,
                "max_retries": 5,
                "temperature": 0.2,
                "top_p": 1,
                "top_k": 1,
                "n": 1,
                "stop": None
            },
            {
                "llm_name": "llama",
                "model_name": "meta-llama/llama-4-scout-17b-16e-instruct",
                "api_key": secrets.get("llama_key", ""),
                "max_tokens": 4096,
                "max_retries": 5,
                "temperature": 0.3,
                "top_p": 1,
                "top_k": 10,
                "n": 1,
                "stop": None
            },
            {
                "llm_name": "claude",
                "model_name": "claude-sonnet-4-5-20250929",
                "api_key": secrets.get("claude_key", ""),
                "max_tokens": 4096,
                "max_retries": 5,
                "temperature": 0.3,
                "top_p": 1,
                "top_k": 10,
                "n": 1,
                "stop": None
            },
            {
                "llm_name": "perplexity",
                "model_name": "sonar-pro",
                "api_key": secrets.get("perplexity_key", ""),
                "max_tokens": 1500,
                "max_retries": 5,
                "temperature": 0.3,
                "top_p": 0.9,
                "top_k": 10,
                "n": 1,
                "stop": None
            }
        ]
        
        os.makedirs(config_dir, exist_ok=True)
        with open(config_path, "w") as f:
            json.dump(config_data, f, indent=4)

# Run this immediately on app launch
ensure_config_exists()

def load_config():
    app_dir = os.path.dirname(os.path.abspath(__file__))
    cfg_path = os.path.join(app_dir, "src", "antarbhukti", "config.json")
    if not os.path.exists(cfg_path):
        return []
    with open(cfg_path, "r", encoding="utf-8") as f:
        return json.load(f)

# ---------------------------
# DATA: Upgrade Templates
# ---------------------------
UPGRADE_DATA = {
    "Reliability": {
        "header": """You are an expert in control software design using IEC 61131-3 Sequential Function Charts (SFCs).
Given an SFC (SFC1) representing a control process, your task is to generate an upgraded version (SFC2) that improves system reliability.
The upgrade must embed reliability concerns while preserving the original behavior under nominal conditions.

---

**SFC1: Original Control Logic**
{sfc_code}

---

**Reliability Requirements**
""",
        "footer": """---

**Instructions for Generating SFC2**

Use the structured format below to define the upgraded SFC (SFC2):

steps = [
    { "name": StepName1, "function": FunctionName1 },
    ...
]
transitions = [
    { "src": StepNameX, "tgt": StepNameY, "guard": GuardCondition1 },
    ...
]
variables = [ var1, var2, ..., additionalVarsIfNeeded ]
initial_step = StepName1

---

**SFC-Specific Guidelines for Upgradation**

1. *SFC Semantics Compliance*
   - Follow IEC 61131-3 execution semantics: steps hold active states; transitions must be evaluated between cycles.
   - Transitions should only occur when all preceding steps are active and the guard condition evaluates to true.

2. *Determinism and Safety*
   - Ensure transitions are deterministic and do not cause ambiguous behavior.
   - Avoid conflicting parallel branches unless explicitly required.

3. *Guard Conditions*
   - Guards must be side-effect-free and should not modify variable states.

4. *Modularity and Naming*
   - Introduce reliability-specific steps (e.g., ErrorHandler, Log, Retry, SafeAbort) clearly and consistently.
   - Avoid overloading existing steps.

5. *State Preservation*
   - Ensure that the upgraded SFC preserves functional equivalence under fault-free execution.
   - Use logging or backup steps to preserve state before transitions into non-recoverable paths.

6. *Control Flow Validity*
   - Every step must have a valid exit transition.
   - Do not leave the system in a deadlock or non-terminal state unless it's an intended final state.

7. *Minimal Disruption Principle*
   - Do not restructure the original logic unless required to fulfill the reliability requirements.
   - Prefer incremental additions (guards, new steps, safe exits) over refactoring core paths.

---

Return only the upgraded SFC2 in the format above. Adherence to IEC SFC rules, and full coverage of all reliability requirements.""",
        "rules": {
            "Input Validation": {
                "when": "If any input variable is out of valid range at the beginning of execution.",
                "action": "Add a ValidateInput step. If validation fails, transition to a ValidationError step that logs the failure and halts control flow."
            },
            "Execution Bound (Iteration or Time)": {
                "when": "A control loop executes beyond a configured maximum count (e.g., 10 iterations).",
                "action": "Use a variable (e.g., count) to track iterations. If count >= threshold, divert to a SafeAbort step that stores current state and stops execution."
            },
            "Intermediate Logging": {
                "when": "After every critical step (e.g., computation, actuator command).",
                "action": "Insert a Log step that records key internal states (n, result, etc.) to support traceability and debugging."
            },
            "Watchdog Monitoring": {
                "when": "A variable (e.g., n, temperature, etc.) becomes undefined, negative, or out of operational range during execution.",
                "action": "Add a guard or WatchdogCheck step. If abnormal state is detected, transition to WatchdogError."
            }
        }
    },
    "Safety": {
        "header": """You are an expert in control software design using IEC 61131-3 Sequential Function Charts (SFCs).
Given an SFC (SFC1) representing a control process, your task is to generate an upgraded version (SFC2) that improves system safety.
The upgrade must embed safety concerns while preserving the original behavior under nominal conditions.

---

**SFC1: Original Control Logic**
{sfc_code}

---

**Safety Requirements (When Language)**
""",
        "footer": """---

**Instructions for Generating SFC2**
Use the structured format below to define the upgraded SFC (SFC2):

steps = [
{ "name": StepName1, "function": FunctionName1 },
...
]
transitions = [
{ "src": StepNameX, "tgt": StepNameY, "guard": GuardCondition1 },
...
]
variables = [ var1, var2, ..., additionalVarsIfNeeded ]
initial_step = StepName1

---

**SFC-Specific Guidelines for Upgradation**

1. SFC Semantics Compliance
Follow IEC 61131-3 execution semantics. Transitions should only occur when all preceding steps are active and the guard condition evaluates to true.

2. Determinism and Safety
Ensure transitions are deterministic and do not cause ambiguous behavior.

3. Guard Conditions
Guards must be side-effect-free and should not modify variable states.

4. Modularity and Naming
Introduce safety-specific steps (e.g., SafetyCheckInput, SafetyLog, TimeoutSafeStop, EmergencyStop) clearly and consistently.

5. State Preservation
Ensure that the upgraded SFC preserves functional equivalence under fault-free execution. Use logging or backup steps to preserve state before transitions into non-recoverable safety paths.

6. Control Flow Validity
Every step must have a valid exit transition. Do not leave the system in a deadlock.

7. Minimal Disruption Principle
Do not restructure the original logic unless required to fulfill the safety requirements. Prefer incremental additions over refactoring core paths.

---

Return only the upgraded SFC2 in the format above. Adherence to IEC SFC rules, and full coverage of all safety requirements.""",
        "rules": {
            "Input Safety Validation": {
                "when": "At the beginning of execution or before any safety-relevant actuation, if any safety-critical input (e.g., sensor values) is missing, undefined, or outside safe bounds.",
                "action": "Add a SafetyCheckInput step to validate the inputs; on failure, transition to SafetyError that logs the issue and safely halts or inhibits actuation."
            },
            "Timeout and Watchdog Safety": {
                "when": "If a motion, mixing, or signal cycle exceeds its safe time or repetition limit, or a monitored variable becomes undefined/out-of-range during execution.",
                "action": "Track a timeout_counter and apply watchdog checks; when limits are exceeded or abnormal states detected, transition to TimeoutSafeStop that safely halts the process and preserves state where applicable."
            },
            "Safe State Logging": {
                "when": "After each safety-relevant cycle or control action that can impact a safety boundary or margin.",
                "action": "Insert a SafetyLog step that records key parameters (e.g., measurements, setpoints, actuator states, and safety margin/status) to provide auditability and diagnostics."
            },
            "Emergency Stop Monitoring": {
                "when": "If an immediate unsafe condition is detected (e.g., jam, overload, collision risk, critical sensor fault, runaway condition).",
                "action": "Add an EmergencyStopCheck; when triggered, transition to EmergencyStop that immediately halts the system safely and records the fault."
            }
        }
    }
}

# --- CSS: Enterprise Styling (Compact) ---
st.markdown("""
<style>
    /* 1. Global Container Spacing - Tightened */
    .block-container {
        padding-top: 1rem !important; 
        padding-bottom: 1rem !important;
        padding-left: 3rem !important;
        padding-right: 3rem !important;
    }
    
    /* 2. Main Banner Style - Slim Version */
    .main-header {
        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        background: linear-gradient(135deg, #0F2027 0%, #203A43 50%, #2C5364 100%);
        padding: 25px 30px; /* Slimmer padding */
        border-radius: 10px;
        color: white;
        text-align: center;
        margin-bottom: 15px; /* Less margin bottom */
        box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        border: 1px solid rgba(255,255,255,0.1);
    }
    
    .main-header h1 { 
        font-size: 1.8rem; /* Smaller font */
        margin: 0;
        font-weight: 700; 
        color: #ffffff; 
        letter-spacing: 1.2px;
        text-shadow: 0 1px 2px rgba(0,0,0,0.3);
    }
    
    .main-header p { 
        font-size: 0.9rem; 
        margin: 2px 0 0 0; 
        font-weight: 300; 
        color: #e0e0e0; 
        letter-spacing: 0.5px;
    }

    /* 3. Metric Cards Styling */
    div[data-testid="metric-container"] {
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        padding: 10px 15px; /* Compact padding */
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    
    /* 4. Log Box */
    .log-box { 
        background-color: #1E1E1E; 
        color: #00FF41; 
        padding: 10px; 
        border-radius: 6px; 
        height: 350px; 
        overflow-y: auto; 
        font-family: 'Courier New', monospace; 
        font-size: 12px; 
        border: 1px solid #333;
    }
    
    /* 5. Warning Box */
    .warning-box {
        background-color: #FFF4E5;
        border-left: 5px solid #FF9800;
        padding: 10px;
        border-radius: 4px;
        margin-bottom: 10px;
        color: #663C00;
        font-size: 0.9rem;
    }
</style>
""", unsafe_allow_html=True)

# --- Header ---
st.markdown("""
    <div class="main-header">
        <h1>LLMA VERIFICATION SUITE</h1>
        <p>PLC Software Upgrade Using LLMs</p>
    </div>
""", unsafe_allow_html=True)

# ---------------------------
# Helper: Data Processing
# ---------------------------
def parse_csv_to_long_format(df, source_filename="unknown"):
    standardized_rows = []
    llm_prefixes = ["GPT4o", "Gemini", "LLaMA", "Claude", "Perplexity"]

    for _, row in df.iterrows():
        for llm in llm_prefixes:
            iter_col = f"{llm}_iter"
            time_col = f"{llm}_time"
            token_col = f"{llm}_tokens"
            
            if iter_col in df.columns and pd.notna(row[iter_col]) and str(row[iter_col]).strip() != "":
                try:
                    iterations = float(row[iter_col])
                    time_val = float(row[time_col]) if (time_col in df.columns and pd.notna(row[time_col]) and row[time_col] != "") else 0.0
                    tokens = float(row[token_col]) if (token_col in df.columns and pd.notna(row[token_col]) and row[token_col] != "") else 0.0
                    cost = (tokens / 1_000_000) * 5.0 
                    
                    standardized_rows.append({
                        "Benchmark Name": row.get("Benchmark Name", "Unknown"),
                        "Type": row.get("Type", "Unknown"),
                        "Model": llm,
                        "Iteration": iterations,
                        "Time": time_val,
                        "Tokens": tokens,
                        "Cost": cost,
                        "Source File": source_filename
                    })
                except ValueError:
                    continue
    return standardized_rows

# --- NEW: Smart Stats Helper (JOB BASED) ---
# Find def get_filesystem_stats(...) and replace it with:

def get_filesystem_stats(root_dir="outputs", start_timestamp=0):
    """
    Smart Stats: Groups files by Base Name. 
    Returns (Total Unique Jobs, Job Success Rate).
    """
    successful_jobs = set()
    failed_attempts = set()
    
    if not os.path.exists(root_dir):
        return 0, 0.0

    for root, dirs, files in os.walk(root_dir):
        if "success" in root or "failed" in root:
            for file in files:
                if file.endswith(".txt") or file.endswith(".json"):
                    full_path = os.path.join(root, file)
                    try:
                        if os.path.getmtime(full_path) >= start_timestamp:
                            # REGEX: Strips _1, _2 suffix to identify the "Job"
                            base_name = re.sub(r'_\d+(\.[a-z]+)$', r'\1', file)
                            
                            if "success" in root:
                                successful_jobs.add(base_name)
                            elif "failed" in root:
                                failed_attempts.add(base_name)
                    except OSError:
                        pass

    # Logic: It is a success if it passed AT LEAST once.
    unique_successes = len(successful_jobs)
    truly_failed_jobs = failed_attempts - successful_jobs
    total_unique_jobs = unique_successes + len(truly_failed_jobs)
    
    rate = (unique_successes / total_unique_jobs * 100.0) if total_unique_jobs > 0 else 0.0
    
    return total_unique_jobs, rate

def load_historical_data(result_root="outputs"):
    all_files = glob.glob(os.path.join(result_root, "batch_report_*.csv"))
    if not all_files:
        default_csv = os.path.join(os.path.dirname(__file__), "NewBenchmark_Sheet1.csv")
        if os.path.exists(default_csv):
            all_files = [default_csv]
    
    if not all_files:
        return pd.DataFrame()

    all_standardized_rows = []
    for filename in all_files:
        try:
            df = pd.read_csv(filename)
            rows = parse_csv_to_long_format(df, os.path.basename(filename))
            all_standardized_rows.extend(rows)
        except Exception:
            continue
            
    if all_standardized_rows:
        return pd.DataFrame(all_standardized_rows)
    return pd.DataFrame()

# ---------------------------
# Helper: DIRECT LLM Call
# ---------------------------
def generate_sfc_upgrade(prompt_text, llm_name="gpt4o"):
    try:
        config_list = load_config()
        target_config = next((item for item in config_list if item["llm_name"].lower() == llm_name.lower()), None)
        if not target_config:
            target_config = next((item for item in config_list if "gpt" in item["llm_name"].lower()), None)
        if not target_config:
            return "Error: No configuration found for LLM in config.json."

        api_key = target_config.get("api_key")
        model_name = target_config.get("model_name")
        
        if "gpt" in llm_name.lower() or "openai" in llm_name.lower():
            try:
                from openai import OpenAI
                client = OpenAI(api_key=api_key)
                response = client.chat.completions.create(
                    model=model_name,
                    messages=[
                        {"role": "system", "content": "You are a PLC coding expert. Output only valid Python/SFC code structures. Do NOT wrap output in markdown blocks."},
                        {"role": "user", "content": prompt_text}
                    ],
                    temperature=0.2
                )
                raw_content = response.choices[0].message.content
                clean_content = re.sub(r"^```[a-zA-Z]*\n", "", raw_content.strip())
                clean_content = re.sub(r"\n```$", "", clean_content.strip())
                return clean_content
            except ImportError:
                return "Error: 'openai' library not installed. Please run 'pip install openai'."
            except Exception as e:
                return f"OpenAI API Error: {str(e)}"
        elif "claude" in llm_name.lower():
             return "# Claude support requires 'anthropic' lib. For this demo, please select GPT-4o."
        return f"# Driver for {llm_name} not directly implemented in this UI tab. Please use GPT-4o."
    except Exception as e:
        return f"Critical Error in Generation: {str(e)}"

# ---------------------------
# Sidebar State & Settings
# ---------------------------
if "uploaded_orig_files" not in st.session_state:
    st.session_state.uploaded_orig_files = []
if "uploaded_mod_files" not in st.session_state:
    st.session_state.uploaded_mod_files = []
if "current_batch_csv" not in st.session_state:
    st.session_state.current_batch_csv = None
if "gen_prompt" not in st.session_state:
    st.session_state.gen_prompt = ""
if "gen_code" not in st.session_state:
    st.session_state.gen_code = ""
if "gen_sfc1" not in st.session_state:
    st.session_state.gen_sfc1 = ""

config_list = load_config()
llm_names = [c.get("llm_name", "unknown") for c in config_list] if config_list else ["gpt4o"]

with st.sidebar:
    st.header("⚙️ Configuration")
    st.markdown("### Select LLM Engines")
    selected_llms = st.multiselect(
        "Choose models to run:",
        options=llm_names,
        default=[llm_names[0]] if llm_names else [],
        help="Select one or multiple models. They will run sequentially for each file."
    )

def add_log_text(logs, msg, panel,key_prefix):
    logs += f"[{datetime.datetime.now().strftime('%H:%M:%S')}] {msg}\n"
    panel.text_area(f"Console Stream - {key_prefix}", logs, height=400, label_visibility="collapsed")
    return logs

# ---------------------------
# MAIN TABS
# ---------------------------
tab_dash, tab_design, tab_upload, tab_run, tab_report = st.tabs([
    "📊 Executive Dashboard",
    "Upgraded SFC Generator",
    "📂 Workstation", 
    "🚀 Processing Engine", 
    "📝 Reports"
])

# --- TAB 1: EXECUTIVE DASHBOARD ---
with tab_dash:
    df_history = load_historical_data()
    
    # 1. Get Real Stats from Disk
    total_unique_jobs, real_success_rate = get_filesystem_stats("outputs")
    
    # This ensures we start at 0/0/0/0 and update ONLY when real work is done.
    if total_unique_jobs > 0 and not df_history.empty:
        
        # Calculate Averages from the CSV data (which now includes your new batch)
        avg_time = df_history['Time'].mean()
        avg_tokens = df_history['Tokens'].mean()
        
        # Row 1: Metrics (Real Data)
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Total Verifications", f"{int(total_unique_jobs)}", delta="Unique Benchmarks")
        col2.metric("Success Rate", f"{real_success_rate:.0f}%", delta="Reliability")
        col3.metric("Avg. Time", f"{avg_time:.1f}s", delta="Speed")
        col4.metric("Avg. Tokens Used", f"{int(avg_tokens):,}", delta="Efficiency")
        
        st.markdown("<div style='margin-bottom: 15px;'></div>", unsafe_allow_html=True)
        
        # Row 2: Charts
        col_g1, col_g2 = st.columns([2, 1])
        with col_g1:
            st.markdown("**Time vs. Iteration Analysis**")
            chart_df = df_history[df_history['Time'] > 0]
            if not chart_df.empty:
                chart = alt.Chart(chart_df).mark_circle(size=80).encode(
                    x=alt.X('Iteration', title='Iterations', axis=alt.Axis(tickMinStep=1, format='d')),
                    y=alt.Y('Time', title='Time (s)'),
                    color=alt.Color('Model', title='Model', scale=alt.Scale(scheme='category10')),
                    tooltip=['Benchmark Name', 'Model', 'Time', 'Iteration', 'Tokens']
                ).interactive().properties(height=300)
                st.altair_chart(chart, use_container_width=True)
            else:
                st.info("Insufficient data for chart.")

        with col_g2:
            st.markdown("**Model Usage**")
            bar_data = df_history['Model'].value_counts().reset_index()
            bar_data.columns = ['Model', 'Count']
            
            bar_chart = alt.Chart(bar_data).mark_bar().encode(
                x=alt.X('Model', axis=alt.Axis(labelAngle=0)),
                y='Count',
                color='Model'
            ).properties(height=300)
            st.altair_chart(bar_chart, use_container_width=True)

    else:
        # EMPTY STATE: Show this on fresh boot (Clean 0/0/0/0)
        st.info("Ready to Verify. Go to 'Workstation' to upload and run your first batch.")
        
        c1, c2, c3, c4 = st.columns(4)
        c1.metric("Total Verifications", "0", delta="Ready")
        c2.metric("Success Rate", "0%", delta="--")
        c3.metric("Avg. Time", "0s", delta="--")
        c4.metric("Avg. Tokens", "0", delta="--")

# --- TAB 2: UPGRADE DESIGNER ---
with tab_design:
    st.header("Upgraded SFC Generator")
    st.markdown("Design and generate a compliant SFC upgrade using AI-assisted Prompt Engineering.")
    col_d1, col_d2 = st.columns([1, 1])
    
    with col_d1:
        st.subheader("1. Source & Intent")
        sfc1_file = st.file_uploader("Upload Original SFC (SFC1)", type=["txt", "st", "xml"], key="design_upload")
        st.markdown("**Upgrade Objective**")
        obj_safety = st.checkbox("Safety", key="obj_safety")
        obj_reliability = st.checkbox("Reliability", value=True, key="obj_reliability")
        if obj_safety: upgrade_type = "Safety"
        else: upgrade_type = "Reliability"
        st.markdown(f"**Select {upgrade_type} Tactics**")
        available_rules = list(UPGRADE_DATA[upgrade_type]["rules"].keys())
        selected_rule_name = None
        for i, rule in enumerate(available_rules):
            default_chk = (i == 0)
            is_checked = st.checkbox(rule, value=default_chk, key=f"rule_{upgrade_type}_{i}")
            if is_checked: selected_rule_name = rule
        if not selected_rule_name: selected_rule_name = available_rules[0]
        default_when = UPGRADE_DATA[upgrade_type]["rules"][selected_rule_name]["when"]
        default_action = UPGRADE_DATA[upgrade_type]["rules"][selected_rule_name]["action"]

    with col_d2:
        st.subheader("2. Requirement Definition")
        st.info(f"Edit the specific requirements for **'{selected_rule_name}'** to guide the LLM.")
        user_when = st.text_area("When (Condition)", value=default_when, height=100)
        user_action = st.text_area("Action (Logic)", value=default_action, height=100)
        if st.button("Generate Upgrade Prompt & Code", type="primary"):
            if sfc1_file is None:
                st.error("Please upload an SFC1 file first.")
            else:
                sfc_content = sfc1_file.getvalue().decode("utf-8")
                if "PROGRAM" in sfc_content and "END_PROGRAM" in sfc_content:
                    try:
                        temp_filename = "temp_convert_input.xml"
                        with open(temp_filename, "w", encoding="utf-8") as tmp: tmp.write(sfc_content)
                        convert_cmd = [sys.executable, "xmltotxt.py", temp_filename]
                        process = subprocess.run(convert_cmd, capture_output=True, text=True, check=True)
                        sfc_content = process.stdout
                        if os.path.exists(temp_filename): os.remove(temp_filename)
                        st.toast("✅ Auto-converted StructuredText to SFC format", icon="🔄")
                    except Exception as e: st.error(f"Error running conversion: {str(e)}")
                st.session_state.gen_sfc1 = sfc_content
                template = UPGRADE_DATA[upgrade_type]
                header = template["header"].format(sfc_code=sfc_content)
                footer = template["footer"]
                rule_block = f"1. {selected_rule_name}\n\nWhen: {user_when}\nAction: {user_action}\n"
                full_prompt = f"{header}\n{rule_block}\n{footer}"
                st.session_state.gen_prompt = full_prompt
                target_llm = selected_llms[0] if selected_llms else "gpt4o"
                with st.spinner(f"Generating Code using {target_llm}..."):
                    generated_code = generate_sfc_upgrade(full_prompt, target_llm)
                    st.session_state.gen_code = generated_code
                st.success("Generation Complete!")

    if st.session_state.gen_prompt:
        st.divider()
        st.subheader("3. Generated Artifacts")
        col_res1, col_res2 = st.columns(2)
        with col_res1:
            st.markdown("**Generated Prompt (Input)**")
            with st.expander("View Full Prompt", expanded=False): st.text(st.session_state.gen_prompt)
            c_btn1, c_btn2 = st.columns([1, 1])
            with c_btn1: st.download_button("📥 Download Prompt (.txt)", st.session_state.gen_prompt, file_name=f"prompt_{upgrade_type.lower()}.txt")
            with c_btn2:
                if st.session_state.gen_sfc1:
                    src_name = sfc1_file.name.rsplit('.', 1)[0] + "_SFC.txt" if sfc1_file else "sfc1_converted.txt"
                    st.download_button("📥 Download Converted Original SFC (.txt)", st.session_state.gen_sfc1, file_name=src_name)
        with col_res2:
            st.markdown("**Generated SFC2 (Output)**")
            with st.expander("View Generated Code", expanded=True): st.code(st.session_state.gen_code, language="python")
            st.download_button("📥 Download SFC2 (.txt)", st.session_state.gen_code, file_name=f"{sfc1_file.name.split('.')[0]}_upgraded.txt" if sfc1_file else "sfc2.txt")
            st.caption("Download this file and upload it to the 'Workstation' tab to verify.")

# --- TAB 3: WORKSTATION ---
with tab_upload:
    st.header("📂 Bulk File Staging")
    st.markdown("""<div class="warning-box"><b>⚠️ Filename Requirements:</b> Pairs are matched alphabetically. Ensure file lists match.</div>""", unsafe_allow_html=True)
    col_up1, col_up2 = st.columns(2)
    with col_up1:
        st.subheader("1. Original SFCs")
        orig_files = st.file_uploader("Upload folder of Original files", type=["txt", "st"], accept_multiple_files=True, key="uploader_orig")
        if orig_files: st.session_state.uploaded_orig_files = orig_files; st.success(f"Loaded {len(orig_files)} files.")
    with col_up2:
        st.subheader("2. Modified SFCs")
        mod_files = st.file_uploader("Upload folder of Modified files", type=["txt", "st"], accept_multiple_files=True, key="uploader_mod")
        if mod_files: st.session_state.uploaded_mod_files = mod_files; st.success(f"Loaded {len(mod_files)} files.")
    if st.session_state.uploaded_orig_files and st.session_state.uploaded_mod_files:
        if len(st.session_state.uploaded_orig_files) != len(st.session_state.uploaded_mod_files): st.warning(f"Mismatch: {len(st.session_state.uploaded_orig_files)} vs {len(st.session_state.uploaded_mod_files)} files.")
        else: st.success("✅ Ready to Process.")

# --- TAB 4: PROCESSING ENGINE ---
with tab_run:
    st.header("🚀 Verification Engine")
    if st.button("▶️ Start Batch Verification", type="primary"):
        if not selected_llms: st.error("⚠️ Please select at least one LLM Engine in the Sidebar.")
        else:
            sorted_orig = sorted(st.session_state.uploaded_orig_files, key=lambda x: x.name)
            sorted_mod = sorted(st.session_state.uploaded_mod_files, key=lambda x: x.name)
            valid_pairs = []
            for o_file, m_file in zip(sorted_orig, sorted_mod): valid_pairs.append({"orig": o_file, "mod": m_file, "name": m_file.name})
            
            if not valid_pairs: st.error("No valid pairs created.")
            else:
                if os.path.exists("uploads"): shutil.rmtree("uploads", ignore_errors=True)
                result_root = "outputs"
                os.makedirs(result_root, exist_ok=True)
                timestamp = int(time.time())
                csv_filename = f"batch_report_{timestamp}.csv"
                session_csv_path = os.path.abspath(os.path.join(result_root, csv_filename))
                st.session_state.current_batch_csv = session_csv_path
                progress_bar = st.progress(0)
                st.info(f"Queued {len(valid_pairs)} pairs on {len(selected_llms)} models.")
                
                for i, pair in enumerate(valid_pairs):
                    pair_id = f"job_{i}"
                    pair_dir = os.path.join("uploads", pair_id)
                    old_dir, new_dir = os.path.join(pair_dir, "old"), os.path.join(pair_dir, "new")
                    os.makedirs(old_dir, exist_ok=True)
                    os.makedirs(new_dir, exist_ok=True)
                    with open(os.path.join(old_dir, pair['orig'].name), "wb") as f: f.write(pair['orig'].getbuffer())
                    with open(os.path.join(new_dir, pair['mod'].name), "wb") as f: f.write(pair['mod'].getbuffer())
                    
                    with st.status(f"[{i+1}/{len(valid_pairs)}] Verifying: {pair['name']}", expanded=True) as status:
                        log_panel = st.empty(); logs = ""
                        driver_path = os.path.join(os.path.dirname(__file__), "src", "antarbhukti", "driver.py")
                        prompt_file = os.path.join(os.path.dirname(__file__), "prompts", "original", "iterative_prompting.txt")
                        os.makedirs(os.path.dirname(prompt_file), exist_ok=True)
                        if not os.path.exists(prompt_file):
                            with open(prompt_file, "w") as ph: ph.write("Provide PLC upgrade rules.")
                        llm_arg = ",".join([x.lower() for x in selected_llms])
                        cmd = [sys.executable, "-u", driver_path, "--src_path", old_dir, "--mod_path", new_dir, "--result_root", result_root, "--prompt_path", prompt_file, "--config_path", os.path.join(os.path.dirname(driver_path), "config.json"), "--llms", llm_arg]
                        env_vars = os.environ.copy()
                        env_vars["BENCHMARK_CSV_PATH"] = session_csv_path
                        try:
                            process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1, env=env_vars)
                            for line in process.stdout:
                                logs = add_log_text(logs, line.rstrip(), log_panel,key_prefix=f"job_{i}")
                            retcode = process.wait()
                            if retcode == 0: status.update(label=f"✅ Verified: {pair['name']}", state="complete", expanded=False)
                            else: status.update(label=f"❌ Failed: {pair['name']}", state="error", expanded=False)
                        except Exception as e: status.update(label="❌ Critical Error", state="error"); st.error(str(e))
                    progress_bar.progress((i + 1) / len(valid_pairs))
                st.success("Batch Queue Processed Successfully!")

# --- TAB 5: REPORTS ---
with tab_report:
    st.header("📝 Reports & Analysis")
    st.markdown("### 1. Current Batch Metrics")
    current_csv = st.session_state.get("current_batch_csv")
    
    if current_csv and os.path.exists(current_csv):
        try:
            try:
                base = os.path.basename(current_csv)
                timestamp_str = base.replace("batch_report_", "").replace(".csv", "")
                batch_start_time = int(timestamp_str)
            except ValueError: batch_start_time = 0

            # Get Stats for THIS Batch
            b_total, b_success_rate = get_filesystem_stats("outputs", start_timestamp=batch_start_time)
            
            df = pd.read_csv(current_csv)
            rows = parse_csv_to_long_format(df, os.path.basename(current_csv))
            if rows:
                batch_df = pd.DataFrame(rows)
                b_time, b_tokens = batch_df['Time'].mean(), batch_df['Tokens'].mean()
                mc1, mc2, mc3, mc4 = st.columns(4)
                mc1.metric("Verifications Run", f"{b_total}", delta="Current Batch")
                mc2.metric("Success Rate", f"{b_success_rate:.1f}%", delta="Real-Time")
                mc3.metric("Avg. Time", f"{b_time:.1f}s", delta="Speed")
                mc4.metric("Avg. Tokens", f"{int(b_tokens):,}", delta="Efficiency")
                st.divider()
            st.dataframe(df, use_container_width=True)
            with open(current_csv, "rb") as f: st.download_button("📥 Download CSV", f, file_name=os.path.basename(current_csv))
        except Exception as e: st.error(f"Error reading batch data: {e}")
    else: st.info("No active batch results.")

    st.divider()
    st.markdown("### 2. Detailed Verification Artifacts")
    report_items = []
    for root, dirs, files in os.walk("outputs"):
        if "success" in root or "failed" in root:
            for file in files:
                full_path = os.path.join(root, file)
                base_name = os.path.splitext(file)[0]
                try: model_name = os.path.basename(os.path.dirname(os.path.dirname(full_path)))
                except: model_name = "Unknown"
                item = {"path": full_path, "file": file, "base": base_name, "ext": os.path.splitext(file)[1], "model": model_name, "time": os.path.getmtime(full_path), "status": "success" if "success" in root else "failed"}
                report_items.append(item)
    
    if report_items:
        report_items.sort(key=lambda x: x["time"], reverse=True)
        unique_runs = {}
        for item in report_items:
            status_icon = "✅" if item["status"] == "success" else "❌"
            key = f"{status_icon} {item['model']} - {item['base']}"
            if key not in unique_runs: unique_runs[key] = {"html": None, "txt": None, "status": item["status"]}
            if item["ext"] == ".html": unique_runs[key]["html"] = item["path"]
            elif item["ext"] == ".txt": unique_runs[key]["txt"] = item["path"]
        
        col_sel, col_empty = st.columns([0.5, 0.5])
        with col_sel: selected_run_key = st.selectbox("Select Verification Run to Inspect", list(unique_runs.keys()))
        selected_run = unique_runs[selected_run_key]
        
        if selected_run["html"]:
            with open(selected_run["html"], 'r', encoding='utf-8') as f:
                html_code = f.read()
                st.download_button("📥 Download HTML Report", html_code, file_name=os.path.basename(selected_run["html"]), mime="text/html", key="dl_html")
                components.html(html_code, height=1200, scrolling=True)
        elif selected_run["status"] == "failed": st.warning("⚠️ No HTML Report found for this failure. Check console logs.")
        
        if selected_run["txt"]:
            label = "Final Corrected SFC Code" if selected_run["status"] == "success" else "Failed SFC Code Snapshot"
            with st.expander(label, expanded=(not selected_run["html"])):
                with open(selected_run["txt"], "r") as f:
                    code_content = f.read()
                    st.code(code_content, language="python")
                    st.download_button("📥 Download Code (.txt)", code_content, file_name=os.path.basename(selected_run["txt"]))
    else: st.warning("No verification artifacts found.")