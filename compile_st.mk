# --- Configuration ---
# Fall back to 'matiec' directory in home folder if environment variable isn't set
MATIEC_INCLUDE_PATH ?= $(HOME)/workspace/matiec/lib

# Target source file variable (override via command line)
SRC ?= nofilefound.st

# --- Executable Verification ---
# Check if iec2iec is available in the system PATH
IEC2IEC_EXISTS := $(shell command -v iec2iec 2> /dev/null)

.PHONY: all check_compiler check_syntax

# Default rule
all: check_compiler check_syntax

# Explicitly check for compiler presence and return exit code 2 if missing
check_compiler:
ifndef IEC2IEC_EXISTS
	@echo "ERROR: 'iec2iec' compiler execution binary not found in your system PATH." >&2
	@echo "Please install matiec from https://github.com/beremiz/matiec or update your PATH variable." >&2
	@exit 2
endif

# Syntax validation rule
check_syntax: $(SRC)
#	@echo "Validating syntax for $(SRC)..."
	@iec2iec -I $(MATIEC_INCLUDE_PATH) $(SRC) > /dev/null
	@echo "Success: $(SRC) compiled without errors."
