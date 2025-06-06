#!/bin/bash

YAML_URL="https://raw.githubusercontent.com/huggingface/ai-deadlines/refs/heads/main/src/data/conferences.yml"
CACHE="./ML_Big3_Countdown/ml_data.json"
TMP=$(mktemp)
YQ_PATH="/opt/homebrew/bin/yq"

# Update if older than 7 days or missing
if [ ! -f "$CACHE" ] || [ $(find "$CACHE" -mtime +7) ]; then
  curl -s "$YAML_URL" | "$YQ_PATH" -o=json > "$TMP"

  # Filter and format relevant conferences, keeping only the newest entry for duplicate titles
  jq -c '
    [.[] | select(.title == "ICLR" or .title == "ICML" or .title == "NeurIPS")]
    | group_by(.title)
    | map(
        sort_by(.year) | reverse | .[0] | {
          name: .title,
          year,
          deadline,
          date,
          place: .venue,
          timezone: (.timezone // "UTC"),
          source: "ML"
        }
      )
  ' "$TMP" > "$CACHE"
fi

cat "$CACHE"
