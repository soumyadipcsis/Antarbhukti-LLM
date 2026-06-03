import json
from pathlib import Path

def rescue_and_split():
    results_file = Path("claude_batch_results.jsonl")
    requests_file = Path("claude_batch_requests.jsonl")
    remainder_file = Path("claude_batch_requests_REMAINDER.jsonl")
    
    # Create a folder to hold your successful JSON upgrades
    out_dir = Path("upgraded_sfcs")
    out_dir.mkdir(exist_ok=True)
    
    successful_ids = set()
    success_count = 0
    error_count = 0
    
    print("🔍 Scanning batch results for successful generations...")
    
    # 1. Extract all the good generations and save them
    with open(results_file, "r") as f:
        for line in f:
            data = json.loads(line.strip())
            custom_id = data.get("custom_id")
            result = data.get("result", {})
            
            if result.get("type") == "succeeded":
                # Extract the actual LLM text response
                llm_content = result["message"]["content"][0]["text"]
                
                # Save it to your output folder
                output_path = out_dir / f"{custom_id}.json"
                with open(output_path, "w") as out_f:
                    json.dump({"id": custom_id, "generation": llm_content}, out_f, indent=2)
                
                successful_ids.add(custom_id)
                success_count += 1
            else:
                error_count += 1

    print(f"✅ Secured {success_count} perfect generations in the '{out_dir.name}' folder!")
    print(f"⚠️ Found {error_count} failed/unprocessed requests due to low balance.")
    
    # 2. Build the Remainder Batch
    print("\n📦 Building the remainder batch...")
    remainder_count = 0
    
    with open(requests_file, "r") as req_f, open(remainder_file, "w") as rem_f:
        for line in req_f:
            req_data = json.loads(line.strip())
            if req_data.get("custom_id") not in successful_ids:
                rem_f.write(line)
                remainder_count += 1
                
    print(f"✅ Saved {remainder_count} missing requests to {remainder_file.name}")

if __name__ == "__main__":
    rescue_and_split()