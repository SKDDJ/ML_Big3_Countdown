#!/bin/bash

CACHE="./ML_Big3_Countdown/ml_data.json"
YQ_PATH="/opt/homebrew/bin/yq"
TMP_DIR=$(mktemp -d)
TMP_FILE="$TMP_DIR/all_confs.yml"

# Update if older than 7 days or missing
if [ ! -f "$CACHE" ] || [ $(find "$CACHE" -mtime +7) ]; then
  # Get the list of conference files from the ccf-deadlines repo
  API_URL="https://api.github.com/repos/ccfddl/ccf-deadlines/contents/_data/conferences"
  
  # Fetch the file list, extract download URLs, and download all of them into a single file
  curl -s "$API_URL" | jq -r '.[].download_url' | xargs curl -s >> "$TMP_FILE"

  # Process the combined YAML file
  cat "$TMP_FILE" | "$YQ_PATH" -o=json | jq -s '
    # Flatten the array of arrays into a single array
    flatten |
    # Filter for the conferences you want
    map(select(.title == "AAAI" or .title == "CVPR" or .title == "ICLR" or .title == "VLDB")) |
    # Format the output
    map(
      {
        name: .title,
        year: .year,
        deadline: .deadline[0], # Taking the first deadline
        date: .date,
        place: .place,
        timezone: .timezone,
        source: "CCF"
      }
    )
  ' > "$CACHE"

  # Clean up the temp directory
  rm -rf "$TMP_DIR"
fi

cat "$CACHE"
