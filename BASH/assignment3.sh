#bash script that automatically fetches aws feed and stores them in a json file
#!/bin/bash
aws=$( curl -s "https://aws.amazon.com/blogs/aws/feed/" )
echo "$aws" > output.json
cat output.json
