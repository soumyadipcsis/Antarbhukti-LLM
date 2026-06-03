import os
import shutil
import random
from pathlib import Path

# --- Configuration ---
# Point these to the folders containing your generated JSONs
INPUT_DIRS = ["layer1", "layer2"] 

# Where the split dataset will live
OUTPUT_BASE_DIR = Path("final_dataset")
TRAIN_DIR = OUTPUT_BASE_DIR / "train"
TEST_DIR = OUTPUT_BASE_DIR / "test"

SPLIT_RATIO = 0.90
RANDOM_SEED = 42 # Locks the randomness so you get the exact same split if you rerun it

def get_seed_name(filename):
    """
    Extracts the base seed name from the filename handling both conventions.
    """
    # First, try the standard "_sfc_iter" delimiter
    if "_sfc_iter" in filename:
        return filename.split("_sfc_iter")[0]
    
    # Next, try the fallback "_iter" delimiter for files that don't have "sfc"
    elif "_iter" in filename:
        return filename.split("_iter")[0]
        
    return None

def main():
    print("Gathering files and extracting seeds...")
    all_files = []
    seed_set = set()

    # 1. Collect all files and identify unique seeds
    for directory in INPUT_DIRS:
        dir_path = Path(directory)
        if not dir_path.exists():
            print(f"Warning: Directory '{directory}' not found. Skipping.")
            continue

        for filepath in dir_path.glob("*.json"):
            seed_name = get_seed_name(filepath.name)
            if seed_name:
                all_files.append((seed_name, filepath))
                seed_set.add(seed_name)

    unique_seeds = sorted(list(seed_set))
    total_seeds = len(unique_seeds)
    
    if total_seeds == 0:
        print("No valid files found. Check your INPUT_DIRS paths.")
        return

    print(f"Found {len(all_files)} total files across {total_seeds} unique seeds.")

    # 2. Shuffle and split the SEEDS (not the individual files)
    random.seed(RANDOM_SEED)
    random.shuffle(unique_seeds)

    split_index = int(total_seeds * SPLIT_RATIO)
    train_seeds = set(unique_seeds[:split_index])
    test_seeds = set(unique_seeds[split_index:])

    print(f"Split: {len(train_seeds)} seeds assigned to Train, {len(test_seeds)} assigned to Test.")

    # 3. Create fresh output directories
    if OUTPUT_BASE_DIR.exists():
        shutil.rmtree(OUTPUT_BASE_DIR)
    TRAIN_DIR.mkdir(parents=True, exist_ok=True)
    TEST_DIR.mkdir(parents=True, exist_ok=True)

    # 4. Route files to their new homes
    train_count = 0
    test_count = 0

    print("Copying files to train/test folders...")
    for seed_name, filepath in all_files:
        if seed_name in train_seeds:
            shutil.copy2(filepath, TRAIN_DIR / filepath.name)
            train_count += 1
        else:
            shutil.copy2(filepath, TEST_DIR / filepath.name)
            test_count += 1

    print("\n=== Split Complete ===")
    print(f"Train Dataset: {train_count} files stored in '{TRAIN_DIR}'")
    print(f"Test Dataset:  {test_count} files stored in '{TEST_DIR}'")

if __name__ == "__main__":
    main()