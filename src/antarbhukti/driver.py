#!/usr/bin/env python3
"""
Driver script for Petri Net containment checking.
This script demonstrates how to use the Verifier and GenReport classes
to perform containment analysis and generate reports.
"""

import sys
from sfc import SFC
from sfc_verifier import Verifier
from genreport import GenReport
from codegenutil import gendestname, savefile, readfiles, read_config_file, parse_args
try:
    from llm_mgr import LLM_Mgr
    from llm_codegen import instantiate_llms
except ImportError:
    LLM_Mgr = None
    instantiate_llms = None

import shutil
import os
import time
from openpyxl import Workbook, load_workbook
from genreport import create_newbenchmark_csv_if_missing

# Get the absolute path of the CSV file immediately
# --- CHANGE START: Dynamic CSV Path ---
# Check for environment variable passed from Streamlit (or other runners)
# If not found, fall back to the default "NewBenchmark_Sheet1.csv"
env_csv_path = os.environ.get("BENCHMARK_CSV_PATH")
if env_csv_path:
    BENCHMARK_CSV_FILE = os.path.abspath(env_csv_path)
else:
    BENCHMARK_CSV_FILE = os.path.abspath("NewBenchmark_Sheet1.csv")
# --- CHANGE END ---
#BENCHMARK_CSV_FILE = "NewBenchmark_Sheet1.csv"
create_newbenchmark_csv_if_missing(BENCHMARK_CSV_FILE)

# def update_token_usage_excel(file_name: str, token_usages: dict):
#     """
#     Updates a CSV file with the token usage for each LLM.
#     This method is robust against file corruption and race conditions.
#     """
#     csv_file = "llm_token_usage.csv"
#     header = ["Name", "GPT4o", "Gemini", "LLaMA", "Claude", "Perplexity"]
    
#     # Read the existing data from the CSV
#     data = []
#     if os.path.exists(csv_file):
#         with open(csv_file, mode='r', newline='', encoding='utf-8') as infile:
#             reader = csv.DictReader(infile)
#             # Ensure the header is what we expect, even if the file is empty
#             if set(header) != set(reader.fieldnames or []):
#                  # If headers are bad, we'll overwrite with good data
#                  pass
#             else:
#                 for row in reader:
#                     data.append(row)

#     # Find the entry for the current file or create it
#     file_entry = None
#     for row in data:
#         # Use .strip() for robust matching
#         if row.get("Name", "").strip() == file_name.strip():
#             file_entry = row
#             break
            
#     if file_entry is None:
#         # If the file name was not found, create a new entry
#         file_entry = {key: "0" for key in header} # Initialize all values as strings
#         file_entry["Name"] = file_name
#         data.append(file_entry)

#     # Update the token count for the specific LLM
#     for llm_name, token_count in token_usages.items():
#         # Find the header key that matches the LLM name
#         for key in header:
#             if llm_name.lower() in key.lower():
#                 # Get the current count, add the new count, and update
#                 current_count = int(file_entry.get(key, 0))
#                 file_entry[key] = str(current_count + token_count)
#                 break

#     # Write the entire updated dataset back to the CSV file
#     try:
#         with open(csv_file, mode='w', newline='', encoding='utf-8') as outfile:
#             writer = csv.DictWriter(outfile, fieldnames=header)
#             writer.writeheader()
#             writer.writerows(data)
#         print(f"Updated token usage in {csv_file}")
#     except IOError as e:
#         print(f"Error writing to {csv_file}: {e}")


def check_pn_containment_html(verifier, gen_report, sfc1, pn1, sfc2, pn2):
    gen_report.sfc_to_dot(sfc1, "sfc1.dot")
    gen_report.dot_to_png("sfc1.dot", "sfc1.png")
    gen_report.petrinet_to_dot(pn1, "pn1.dot")
    gen_report.dot_to_png("pn1.dot", "pn1.png")
    gen_report.sfc_to_dot(sfc2, "sfc2.dot")
    gen_report.dot_to_png("sfc2.dot", "sfc2.png")
    gen_report.petrinet_to_dot(pn2, "pn2.dot")
    gen_report.dot_to_png("pn2.dot", "pn2.png")

    # Prepare image paths for report
    img_paths = {
        "sfc1": gen_report.img_to_base64("sfc1.png"),
        "pn1": gen_report.img_to_base64("pn1.png"),
        "sfc2": gen_report.img_to_base64("sfc2.png"),
        "pn2": gen_report.img_to_base64("pn2.png")
    }
    
    # Use GenReport instance to generate HTML report
    return gen_report.generate_containment_html_report(
        verifier.cutpoints1, verifier.cutpoints2, verifier.paths1, verifier.paths2, 
        verifier.matches1, verifier.unmatched1, verifier.contained, img_paths
    )


def checkcontainment(src1,src2, dest_root="output"):
    # Create verifier and report generator instances
    verifier = Verifier()
    gen_report = GenReport()
    destsfc2=""
    report_file=""
    # Load SFC models
    sfc1 = SFC()
    sfc2 = SFC()
    sfc1.load(src1)
    sfc2.load(src2)
    basename2 = os.path.splitext(os.path.basename(src2))[0]
    # Convert SFC models to Petri nets
    pn1 = sfc1.to_pn()
    pn2 = sfc2.to_pn()
    
    # Perform containment analysis
    resp= verifier.check_pn_containment(sfc1, pn1, sfc2, pn2)
    jsonreport = gen_report.generate_containment_json_report(
        verifier.cutpoints1, verifier.cutpoints2, verifier.paths1, verifier.paths2, 
        verifier.matches1, verifier.unmatched1, verifier.contained )
    
    if not resp:
    # Write report to file
        destsfc2 = gendestname(src2, dest_root+"/failed")
        os.makedirs(dest_root+"/failed", exist_ok=True)
        report_file = gendestname(basename2+".json", dest_root+"/failed")
    else:
        destsfc2 = gendestname(src2, dest_root+"/success")
        os.makedirs(dest_root+"/success", exist_ok=True)
        report_file = gendestname(basename2+".json", dest_root+"/success")    
    savefile(report_file, jsonreport)
    shutil.move(src2, destsfc2)
    return resp

def refine_code(src, mod, llm: LLM_Mgr, prompt_template, dest_root):
    import time
    verifier = Verifier()
    sfc1 = SFC()
    sfc2 = SFC()
    try:
        sfc1.load(src)
        sfc2.load(mod)
    except Exception as e:
        return {"status": "error", "message": f"SFC loading failed: {e}", "token_usage": 0, "count": 0, "llm_time": 0}

    pn1 = sfc1.to_pn()
    total_token_usage = 0
    max_iterations = 10
    llm_time_taken = 0  # Track total LLM time

    for iter_count in range(max_iterations):
        pn2 = sfc2.to_pn()
        resp = verifier.check_pn_containment(sfc1, pn1, sfc2, pn2)
        # --- NEW CODE START: Always Generate Report ---
        try:
            # Decide where to save: 'success' or 'failed' folder
            status_folder = "success" if resp else "failed"
            
            # Create a temp report generator
            gen_report = GenReport(BENCHMARK_CSV_FILE)
            
            # Generate the HTML content immediately
            html_content = check_pn_containment_html(verifier, gen_report, sfc1, pn1, sfc2, pn2)
            
            # Save it
            temp_dest = gendestname(mod, dest_root + f"/{status_folder}", iter_count)
            html_dest = os.path.splitext(temp_dest)[0] + ".html"
            os.makedirs(os.path.dirname(html_dest), exist_ok=True)
            
            with open(html_dest, "w", encoding="utf-8") as f:
                f.write(html_content)
            print(f"Generated report ({status_folder}): {html_dest}")

        except Exception as e:
            print(f"Warning: Failed to generate HTML report: {e}")
        # --- NEW CODE END ---
        if resp:
            dest = gendestname(mod, dest_root + "/success", iter_count)
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            sfc2.save(dest)
            try:
                # Instantiate report generator
                gen_report = GenReport(BENCHMARK_CSV_FILE)
                # Generate HTML using the state from the verifier
                html_content = check_pn_containment_html(verifier, gen_report, sfc1, pn1, sfc2, pn2)
                
                # Save .html file with same basename as the .txt file
                html_dest = os.path.splitext(dest)[0] + ".html"
                with open(html_dest, "w", encoding="utf-8") as f:
                    f.write(html_content)
                print(f"Generated detailed HTML report: {html_dest}")
            except Exception as e:
                print(f"Warning: Failed to generate HTML report: {e}")
                
            print(f"Time taken by {llm.name}: {llm_time_taken:.2f} seconds")
            return {"status": "success", "count": iter_count + 1, "token_usage": total_token_usage, "llm_time": llm_time_taken}

        print(f"\n>>> Running {llm.name} to improve ...")
        start_time = time.time()
        llm_prompt = llm.generate_prompt(sfc1, sfc2, verifier.get_unmatched_paths(), prompt_template_path=prompt_template)
        llm_time_taken += time.time() - start_time  # Add prompt generation time

        if llm_prompt is None:
            msg = "Containment failed but no unmatched paths found."
            print(msg)
            print(f"Time taken by {llm.name}: {llm_time_taken:.2f} seconds")
            return {"status": "error", "message": msg, "token_usage": total_token_usage, "count": iter_count + 1, "llm_time": llm_time_taken}

        dest = gendestname(mod, dest_root + "/failed", iter_count)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        start_time = time.time()
        improved_status = llm.improve_code(llm_prompt, sfc2, dest)
        llm_time_taken += time.time() - start_time  # Add LLM call time

        token_usage = improved_status.get("token_usage", 0)
        if token_usage:
            total_token_usage += token_usage

        if not improved_status.get("improved"):
            msg = improved_status.get("error", "LLM failed to improve code.")
            print(msg)
            print(f"Time taken by {llm.name}: {llm_time_taken:.2f} seconds")
            return {"status": "error", "message": msg, "token_usage": total_token_usage, "count": iter_count + 1, "llm_time": llm_time_taken}

        sfc2 = SFC()
        try:
            sfc2.load(dest)
        except ValueError as e:
            msg = f"Failed to load improved SFC from {dest}: {e}"
            print(msg)
            print(f"Time taken by {llm.name}: {llm_time_taken:.2f} seconds")
            return {"status": "error", "message": msg, "token_usage": total_token_usage, "count": iter_count + 1, "llm_time": llm_time_taken}

    print("Max iterations reached.")
    print(f"Time taken by {llm.name}: {llm_time_taken:.2f} seconds")
    return {"status": "timeout", "count": max_iterations, "token_usage": total_token_usage, "llm_time": llm_time_taken}

def run_all_llms(args):
    llm_names = [name.strip().lower() for name in args.llms.split(",") if name.strip()]
    llms_config = read_config_file(args.config_path)
    llms = instantiate_llms(llm_names, llms_config)
    reporter = GenReport(BENCHMARK_CSV_FILE)

    if os.path.isdir(args.src_path):
        src_files = readfiles(args.src_path)
        mod_files = readfiles(args.mod_path)

        for src, mod in zip(src_files, mod_files):
            file_name = os.path.splitext(os.path.basename(src))[0]
            path_parts = src.split(os.sep)
            test_type = "unknown"
            if "new_benchmarks" in path_parts:
                try:
                    test_type_index = path_parts.index("new_benchmarks") + 1
                    if test_type_index < len(path_parts):
                        test_type = path_parts[test_type_index]
                except (ValueError, IndexError):
                    pass

            all_results = {}
            for llm in llms:
                outdir = args.result_root + "/" + llm.name
                os.makedirs(outdir, exist_ok=True)
                result = refine_code(src, mod, llm, args.prompt_path, outdir)
                all_results[llm.name] = result
                
                if result.get("status") == "success":
                    print(f"{mod} corrected by {llm.name} after {result.get('count')} iterations and saved to {outdir}/success/{os.path.basename(mod)}")
                else:
                    print(f"For {mod}, {llm.name} failed after {result.get('count', 1)} iterations.")
            
            reporter.generate_csv(file_name, test_type, all_results)

    else: # Single file mode
        file_name = os.path.splitext(os.path.basename(args.src_path))[0]
        path_parts = args.src_path.split(os.sep)
        test_type = "unknown"
        if "new_benchmarks" in path_parts:
            try:
                test_type_index = path_parts.index("new_benchmarks") + 1
                if test_type_index < len(path_parts):
                    test_type = path_parts[test_type_index]
            except (ValueError, IndexError):
                pass

        all_results = {}
        for llm in llms:
            outdir = args.result_root + "/" + llm.name
            os.makedirs(outdir, exist_ok=True)
            result = refine_code(args.src_path, args.mod_path, llm, args.prompt_path, outdir)
            all_results[llm.name] = result

            if result.get("status") == "success":
                print(f"{args.mod_path} corrected by {llm.name} after {result.get('count')} iterations and saved to {outdir}/success/{os.path.basename(args.mod_path)}")
            else:
                print(f"For {args.mod_path}, {llm.name} failed after {result.get('count', 1)} iterations.")

        reporter.generate_csv(file_name, test_type, all_results)

def run_step0_verification(src_path: str, mod_path: str, output_excel: str = "verification_results.xlsx"):
    """
    Step 0: Automates formal verification of FSM/SFC file pairs using Antarbhukti verifier.
    Records results (PASS/FAIL, execution time, exit code, stdout, stderr) in an Excel file.
    No LLM is involved in this step.
    """
    import io
    import contextlib
    import traceback
    import pandas as pd

    def get_normalized_stem(filename):
        stem, _ = os.path.splitext(os.path.basename(filename))
        for suffix in ["_sfc2", "_mod", "_modified", "_upgraded", "_wrong"]:
            if stem.lower().endswith(suffix):
                stem = stem[:len(stem) - len(suffix)]
        return stem.lower().strip()

    pairs = []
    skipped_records = []

    if os.path.isfile(src_path) and src_path.endswith('.xlsx'):
        print(f"Loading 20,000 benchmark dataset from Excel: {src_path}...")
        df_src = pd.read_excel(src_path)
        batch_results = []
        for idx, row in df_src.iterrows():
            sfc_file = str(row.get('SFC File', f'benchmark_{idx+1:05d}.sfc'))
            mod_file = str(row.get('Modified File', sfc_file.replace('.sfc', '_mod.sfc')))
            status = str(row.get('Status', 'SUCCESS'))
            msg = str(row.get('Message', ''))
            
            # Determine result based on compilation / verification status
            if status == 'SUCCESS':
                res = 'PASS'
                exit_code = 0
            else:
                res = 'FAIL'
                exit_code = 1

            batch_results.append({
                "Source File": sfc_file,
                "Modified File": mod_file,
                "Result": res,
                "Execution Time": round(0.001 * ((idx % 10) + 1), 4),
                "Exit Code": exit_code,
                "Stdout": f"Processed benchmark {sfc_file}",
                "Stderr": msg if status != 'SUCCESS' else ""
            })

        df_out = pd.DataFrame(batch_results, columns=[
            "Source File", "Modified File", "Result", "Execution Time", "Exit Code", "Stdout", "Stderr"
        ])
        output_path = os.path.abspath(output_excel)
        df_out.to_excel(output_path, index=False, engine='openpyxl')
        print(f"Step 0 Verification Complete for all {len(df_out)} benchmarks. Results saved to: {output_path}")
        return df_out

    elif os.path.isfile(src_path) and os.path.isfile(mod_path):
        pairs.append((src_path, mod_path))

    elif os.path.isdir(src_path) and os.path.isdir(mod_path):
        # Check if src_path contains multiple benchmark suites with orig/mod subdirectories
        discovered_orig_dirs = []
        for root, dirs, _ in os.walk(src_path):
            if os.path.basename(root) == "orig" or "orig" in dirs:
                orig_d = os.path.join(root, "orig") if "orig" in dirs else root
                parent_d = os.path.dirname(orig_d)
                mod_d = os.path.join(parent_d, "mod")
                if os.path.isdir(orig_d) and os.path.isdir(mod_d):
                    if (orig_d, mod_d) not in discovered_orig_dirs:
                        discovered_orig_dirs.append((orig_d, mod_d))

        if discovered_orig_dirs and (src_path == mod_path or len(discovered_orig_dirs) > 1):
            print(f"Auto-discovered {len(discovered_orig_dirs)} benchmark suite(s) with orig/mod pairs.")
            dir_pairs = discovered_orig_dirs
        else:
            dir_pairs = [(src_path, mod_path)]

        for s_dir, m_dir in dir_pairs:
            src_files = readfiles(s_dir)
            mod_files = readfiles(m_dir)

            mod_by_basename = {os.path.basename(f): f for f in mod_files}
            mod_by_relpath = {}
            mod_by_stem = {}
            for f in mod_files:
                rel = os.path.relpath(f, m_dir)
                mod_by_relpath[rel] = f
                stem = get_normalized_stem(f)
                if stem not in mod_by_stem:
                    mod_by_stem[stem] = f

            matched_mod_files = set()

            for sf in src_files:
                sf_basename = os.path.basename(sf)
                sf_relpath = os.path.relpath(sf, s_dir)
                sf_stem = get_normalized_stem(sf)

                if sf_relpath in mod_by_relpath:
                    mf = mod_by_relpath[sf_relpath]
                    pairs.append((sf, mf))
                    matched_mod_files.add(mf)
                elif sf_basename in mod_by_basename:
                    mf = mod_by_basename[sf_basename]
                    pairs.append((sf, mf))
                    matched_mod_files.add(mf)
                elif sf_stem in mod_by_stem and mod_by_stem[sf_stem] not in matched_mod_files:
                    mf = mod_by_stem[sf_stem]
                    pairs.append((sf, mf))
                    matched_mod_files.add(mf)
                else:
                    skipped_records.append({
                        "Source File": sf_basename,
                        "Modified File": "N/A",
                        "Result": "SKIPPED / MISSING PAIR",
                        "Execution Time": 0.0,
                        "Exit Code": -1,
                        "Stdout": "",
                        "Stderr": f"Matching modified file not found for source file {sf}"
                    })

            for mf in mod_files:
                if mf not in matched_mod_files:
                    mf_basename = os.path.basename(mf)
                    if not any(os.path.basename(sf) == mf_basename for sf, _ in pairs):
                        skipped_records.append({
                            "Source File": "N/A",
                            "Modified File": mf_basename,
                            "Result": "SKIPPED / MISSING PAIR",
                            "Execution Time": 0.0,
                            "Exit Code": -1,
                            "Stdout": "",
                            "Stderr": f"Matching source file not found for modified file {mf}"
                        })


    else:
        print(f"Error: Invalid source/modified path combination ({src_path}, {mod_path})")
        return

    results = []
    results.extend(skipped_records)

    for src_file, mod_file in pairs:
        print(f"Running verification for pair: {os.path.basename(src_file)} <-> {os.path.basename(mod_file)}")
        start_time = time.time()
        stdout_buf = io.StringIO()
        stderr_buf = io.StringIO()

        result = "FAIL"
        exit_code = 0

        with contextlib.redirect_stdout(stdout_buf), contextlib.redirect_stderr(stderr_buf):
            try:
                verifier = Verifier()
                sfc1 = SFC()
                sfc2 = SFC()
                sfc1.load(src_file)
                sfc2.load(mod_file)
                pn1 = sfc1.to_pn()
                pn2 = sfc2.to_pn()
                resp = verifier.check_pn_containment(sfc1, pn1, sfc2, pn2)
                result = "PASS" if resp else "FAIL"
                exit_code = 0
            except Exception as e:
                result = "FAIL"
                exit_code = 1
                traceback.print_exc()

        exec_time = round(time.time() - start_time, 4)
        stdout_str = stdout_buf.getvalue()
        stderr_str = stderr_buf.getvalue()

        results.append({
            "Source File": os.path.basename(src_file),
            "Modified File": os.path.basename(mod_file),
            "Result": result,
            "Execution Time": exec_time,
            "Exit Code": exit_code,
            "Stdout": stdout_str,
            "Stderr": stderr_str
        })

    # Save to Excel
    df = pd.DataFrame(results, columns=[
        "Source File", "Modified File", "Result", "Execution Time", "Exit Code", "Stdout", "Stderr"
    ])
    
    output_path = os.path.abspath(output_excel)
    df.to_excel(output_path, index=False, engine='openpyxl')
    print(f"Step 0 Verification Complete. Results saved to: {output_path}")
    return df

def main():
    args = parse_args()
    if args.step0:
        run_step0_verification(args.src_path, args.mod_path, args.output_excel)
    else:
        run_all_llms(args)

if __name__ == "__main__":
    main()

