#!/usr/bin/env python3
"""
SCRIPT 1: List all items on the Miro board and save to JSON.
Handles pagination automatically.
"""

import json
import os
import requests

# Load config from .env
def load_env():
    env = {}
    env_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env")
    with open(env_path) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, value = line.split("=", 1)
                env[key.strip()] = value.strip()
    return env

config = load_env()
TOKEN = config["MIRO_TOKEN"]
BOARD_ID = config["BOARD_ID"]

HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Accept": "application/json",
}

def get_all_items():
    """Fetch all items from the board with pagination."""
    all_items = []
    cursor = None
    page = 1

    while True:
        url = f"https://api.miro.com/v2/boards/{BOARD_ID}/items?limit=50"
        if cursor:
            url += f"&cursor={cursor}"

        print(f"Fetching page {page}...")
        response = requests.get(url, headers=HEADERS)

        if response.status_code != 200:
            print(f"ERROR {response.status_code}: {response.text[:300]}")
            break

        data = response.json()
        items = data.get("data", [])
        all_items.extend(items)
        print(f"  Got {len(items)} items (total: {len(all_items)})")

        cursor = data.get("cursor")
        if not cursor or not items:
            break
        page += 1

    return all_items

def main():
    print("=" * 70)
    print("  MIRO ITEM LISTER - Board CLAUDE_SOAL")
    print("=" * 70)

    items = get_all_items()

    # Save raw JSON
    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "miro_all_items.json")
    with open(output_path, "w") as f:
        json.dump(items, f, indent=2, ensure_ascii=False)

    print(f"\nTotal items: {len(items)}")
    print(f"Saved to: {output_path}")

    # Summary by type
    types = {}
    for item in items:
        t = item.get("type", "unknown")
        types[t] = types.get(t, 0) + 1

    print("\nBreakdown by type:")
    for t, count in sorted(types.items(), key=lambda x: -x[1]):
        print(f"  {t}: {count}")

if __name__ == "__main__":
    main()
