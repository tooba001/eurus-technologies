#bash script that automatically fetches aws feed and stores them in a json file
#!/bin/bash
rss_feed="https://aws.amazon.com/blogs/aws/feed/"
output_file=aws_rss.json
RSS_FEED=$(curl -s "$rss_feed")
echo "$RSS_FEED" | jq -c '.rss.channel.item[]'>output_file
