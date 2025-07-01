#!/bin/bash

# Path to the cache file
CACHE="./ML_Big3_Countdown/ml_data.json"
# Directory to clone the ccf-deadlines repo
CCF_DEADLINES_DIR=$(mktemp -d)
# Path to yq
YQ_PATH="/opt/homebrew/bin/yq"

# Update if older than 7 days or missing
if [ ! -f "$CACHE" ] || [ $(find "$CACHE" -mtime +7) ]; then
  # Clone the ccf-deadlines repository
  git clone https://github.com/ccfddl/ccf-deadlines.git "$CCF_DEADLINES_DIR"

  # Process the YAML files
  find "$CCF_DEADLINES_DIR/_data/conferences" -name "*.yml" -print0 | xargs -0 "$YQ_PATH" -o=json | jq -s '
    map(
      {
        name: .title,
        year: .year,
        deadline: .deadline,
        date: .date,
        place: .place,
        timezone: .timezone,
        source: "CCF"
      }
    ) |
    # Filter for the conferences you want
    map(select(.name == "AAAI" or .name == "CVPR" or .name == "ICLR" or .name == "VLDB"))
  ' > "$CACHE"

  # Clean up the cloned repo
  rm -rf "$CCF_DEADLINES_DIR"
fi

cat "$CACHE"