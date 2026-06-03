import json
import time
import sys
from pathlib import Path
from anthropic import Anthropic

# ==========================================
# CONFIGURATION
# ==========================================
API_KEY = "sk-XXX"  # Replace with your actual Anthropic API key

INPUT_FILE = Path("claude_batch_requests.jsonl")
OUTPUT_FILE = Path("claude_batch_results.jsonl")

def run_claude_batch_pipeline():
    if not INPUT_FILE.exists():
        print(f"❌ Error: Could not find {INPUT_FILE.name}.")
        sys.exit(1)

    client = Anthropic(api_key=API_KEY)

    # 1. Load the requests from our JSONL file
    print("📦 Packing requests into batch payload...")
    batch_requests = []
    with open(INPUT_FILE, "r") as f:
        for line in f:
            batch_requests.append(json.loads(line))

    # 2. Create the Batch Job directly
    print("🚀 Firing Batch Job to Anthropic...")
    message_batch = client.messages.batches.create(
        requests=batch_requests
    )
    batch_id = message_batch.id
    print(f"✅ Batch Job created! Batch ID: {batch_id}")
    print("⏳ Entering monitoring mode. You can leave this running...")

    # 3. Monitor Status
    while True:
        job = client.messages.batches.retrieve(batch_id)
        status = job.processing_status
        counts = job.request_counts
        
        # Anthropic provides counts differently
        print(f"📊 Status: {status.upper()} | Processing: {counts.processing} | Succeeded: {counts.succeeded} | Errored: {counts.errored} | Expired: {counts.expired}", end="\r")

        if status == "ended":
            print("\n🎉 Batch Job Completed!")
            break
        elif status in ["canceling", "canceled"]:
            print(f"\n❌ Batch Job Stopped: {status}")
            sys.exit(1)
            
        time.sleep(60)

    # 4. Stream and Download Results
    print("📥 Downloading and streaming results...")
    
    # Anthropic streams the results one by one to save memory
    success_count = 0
    error_count = 0
    
    with open(OUTPUT_FILE, "w") as f:
        for result in client.messages.batches.results(batch_id):
            # Write the raw JSON string representation of the result to the file
            f.write(result.model_dump_json() + "\n")
            
            if result.result.type == "succeeded":
                success_count += 1
            else:
                error_count += 1
                
    print(f"✅ Saved results to: {OUTPUT_FILE.name}")
    print(f"🏁 Pipeline finished. Successful generations: {success_count}, Errors: {error_count}")

if __name__ == "__main__":
    run_claude_batch_pipeline()