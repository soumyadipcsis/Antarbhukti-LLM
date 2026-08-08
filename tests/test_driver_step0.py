#!/usr/bin/env python3
"""
Unit tests for Step 0 formal verification in driver.py.
"""

import os
import sys
import tempfile
import pytest
import pandas as pd

from src.antarbhukti.driver import run_step0_verification

def test_run_step0_verification_single_file(tmp_path):
    src_file = "orig/dec2hex.txt"
    mod_file = "mod/dec2hex.txt"
    
    if not os.path.exists(src_file) or not os.path.exists(mod_file):
        pytest.skip("Test data files orig/dec2hex.txt or mod/dec2hex.txt not found")
        
    excel_out = tmp_path / "verification_results.xlsx"
    df = run_step0_verification(src_file, mod_file, output_excel=str(excel_out))
    
    assert os.path.exists(excel_out)
    assert len(df) == 1
    assert "Source File" in df.columns
    assert "Modified File" in df.columns
    assert "Result" in df.columns
    assert "Execution Time" in df.columns
    assert "Exit Code" in df.columns
    assert "Stdout" in df.columns
    assert "Stderr" in df.columns
    assert df["Source File"].iloc[0] == "dec2hex.txt"
    assert df["Modified File"].iloc[0] == "dec2hex.txt"
    assert df["Result"].iloc[0] in ["PASS", "FAIL"]


def test_run_step0_verification_dir(tmp_path):
    src_dir = "orig"
    mod_dir = "mod"
    
    if not os.path.isdir(src_dir) or not os.path.isdir(mod_dir):
        pytest.skip("orig or mod directory not found")
        
    excel_out = tmp_path / "verification_results.xlsx"
    df = run_step0_verification(src_dir, mod_dir, output_excel=str(excel_out))
    
    assert os.path.exists(excel_out)
    assert len(df) > 0
    assert "Result" in df.columns
    for res in df["Result"]:
        assert res in ["PASS", "FAIL", "SKIPPED / MISSING PAIR"]
