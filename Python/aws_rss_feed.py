import requests
import json
import time
from bs4 import BeautifulSoup

RSS_FEED_URL = "https://aws.amazon.com/about-aws/whats-new/recent/feed/"
JSON_FILE_PATH = "aws_feed.json"
FETCH_INTERVAL = 15 * 60  # 15 minutes in seconds

def fetch_aws_feeds():
    """
    Fetches AWS RSS feeds and returns a list of feed entries.
    """
    try:
        response = requests.get(RSS_FEED_URL)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, "html.parser")
            items = soup.find_all("item")
            feeds = []
            for item in items:
                title = item.title.text if item.title else "No title"
                link = item.link.text if item.link else "No link"
                published_date = item.pubDate.text if item.pubDate else "No date"
                feed_entry = {
                    "title": title,
                    "link": link,
                    "published_date": published_date
                }
                feeds.append(feed_entry)
            return feeds
        else:
            print("Failed to fetch AWS feeds. Status code:", response.status_code)
            return []
    except requests.RequestException as e:
        print("Error fetching AWS feeds:", str(e))
        return []



def load_existing_feeds():
    """
    Loads existing feed entries from the JSON file.
    """
    try:
        with open(JSON_FILE_PATH, "r") as file:
            existing_feeds = json.load(file)
        return existing_feeds
    except FileNotFoundError:
        return []
    except json.JSONDecodeError:
        print("Invalid JSON format in the file:", JSON_FILE_PATH)
        return []


def save_feeds_to_json(feeds):
    """
    Saves feed entries to the JSON file.
    """
    with open(JSON_FILE_PATH, "w") as file:
        json.dump(feeds, file, indent=4)


def main():
    while True:
        # Fetch AWS feeds
        new_feeds = fetch_aws_feeds()

        # Load existing feeds from JSON file
        existing_feeds = load_existing_feeds()

        # Avoid duplicates
        for new_feed in new_feeds:
            if new_feed not in existing_feeds:
                existing_feeds.append(new_feed)

        # Save updated feeds to JSON file
        save_feeds_to_json(existing_feeds)

        print("Updated AWS feeds saved to JSON.")

        # Wait for next fetch interval
        time.sleep(FETCH_INTERVAL)


if __name__ == "__main__":
    main()

