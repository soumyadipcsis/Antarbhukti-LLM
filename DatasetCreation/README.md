# Folder Guide

### Athish_<...> Files
- Already in **SFC format**, from:
  - `benchmarks/Benchmark-Source-OSCAT.py`
  - `Benchmarks.py`

### module_export_<...> Files
- **Unfiltered ST files** (many irrelevant stateless mathematical codes) from OSCAT.

### batchN_filtered_<...> Files
- **Filtered ST files** with stateful logic.

### Scripts
- **filter_st.py**: Script to extract a filtered list of files from `module_export`.
- **st_to_sfc_parser.py**: Script to convert ST to SFC format.

### Examples
- **test_st2.st**: Example of an ST file.
- **test_st2_sfc.txt**: Example of its converted SFC by the script.