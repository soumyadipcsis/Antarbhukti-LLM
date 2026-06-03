import requests

def test_deepseek_key(api_key):
    url = "https://api.deepseek.com/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "deepseek-chat",
        "messages": [{"role": "user", "content": "Hi"}],
        "stream": False
    }

    try:
        response = requests.post(url, headers=headers, json=payload, timeout=10)
        if response.status_code == 200:
            print("✅ Success! Your API key is working.")
            print(f"Response: {response.json()['choices'][0]['message']['content']}")
        else:
            print(f"❌ Failed. Status Code: {response.status_code}")
            print(f"Error Details: {response.text}")
    except Exception as e:
        print(f"⚠️ An error occurred: {e}")

if __name__ == "__main__":
    # Replace with your actual key
    YOUR_KEY = "sk-XXX" 
    test_deepseek_key(YOUR_KEY)