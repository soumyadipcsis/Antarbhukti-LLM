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
from llm_mgr import LLM_Mgr
from llm_codegen import instantiate_llms
import shutil
import os

def check_pn_containment_html( verifier, gen_report, sfc1, pn1, sfc2, pn2):
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

def refine_code(src, mod, llm:LLM_Mgr, prompt_template, dest_root):
    # --- MODIFIED FUNCTION ---
    # Now returns a tuple: (iteration_count, success_boolean, total_tokens_used)
    verifier = Verifier()
    sfc1 = SFC()
    sfc2 = SFC()
    sfc1.load(src)
    sfc2.load(mod)
    pn1 = sfc1.to_pn()
    
    total_tokens_used = 0
    max_iterations = 10

    for iter_count in range(max_iterations):
        pn2 = sfc2.to_pn()
        is_contained, unmatched_paths = verifier.check_pn_containment(sfc1, pn1, sfc2, pn2)
        
        if not is_contained:
            print(f"\n>>> Running {llm.name} to improve (Iteration {iter_count + 1})...")
            llm_prompt = llm.generate_prompt(sfc1, sfc2, unmatched_paths, prompt_template_path=prompt_template)
            if llm_prompt is None:
                print("No unmatched paths to improve on.")
                return (iter_count + 1, False, total_tokens_used)
            
            dest = gendestname(mod, os.path.join(dest_root, "failed"), iter_count)
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            
            improved, tokens_this_iteration = llm.improve_code(llm_prompt, sfc2, dest)
            
            if tokens_this_iteration is not None:
                total_tokens_used += tokens_this_iteration
            
            if not improved:
                print("No further improvement possible or LLM failed.")
                return (iter_count + 1, False, total_tokens_used)
            
            sfc2.load(dest)
        else:
            dest = gendestname(mod, os.path.join(dest_root, "success"), iter_count)
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            sfc2.save(dest)
            return (iter_count + 1, True, total_tokens_used)
            
    print("No further improvement possible - max iteration reached.")
    return (iter_count + 1, False, total_tokens_used)   

def refine_all(args, llm):
    # --- MODIFIED FUNCTION ---
    # Correctly captures token data within the loop.
    outdir = os.path.join(args.result_root, llm.name)
    os.makedirs(outdir, exist_ok=True)
    token_data = {} # Initialize token data dictionary for this run

    file_pairs = []
    if os.path.isfile(args.src_path):
        file_pairs.append((args.src_path, args.mod_path))
    else:
        srcfiles = readfiles(args.src_path)
        modfiles = readfiles(args.mod_path)
        file_pairs.extend(zip(srcfiles, modfiles))

    for src, mod in file_pairs:
        process_name = os.path.splitext(os.path.basename(src))[0]
        # Unpack all three return values, including the token count
        itr, iscontained, tokens_used = refine_code(src, mod, llm, args.prompt_path, outdir)
        
        print(f"Result for '{process_name}': Success: {iscontained} in {itr} iteration(s). Total Tokens: {tokens_used}")
        
        # Correctly populate the token data
        if process_name not in token_data:
            token_data[process_name] = {}
        token_data[process_name][llm.name] = tokens_used

    # Save data to Excel after processing all files for the current LLM
    if token_data:
        save_token_usage_to_excel(token_data, "llm_token_usage.xlsx")

def run_all_llms(args):
    llm_names = [name.strip().lower() for name in args.llms.split(",") if name.strip()]
    llms_config = read_config_file(args.config_path)
    llms= instantiate_llms(llm_names, llms_config )
    for llm in llms:
        refine_all(args, llm)

def main():
    args = parse_args()
#    checkcontainment("./src/dec2hex.txt", "./dec2hex_mod_wrong_3.txt")
    run_all_llms(args)

if __name__ == "__main__":
    main()
