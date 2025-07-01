#!/bin/bash

# CCF deadlines repository base URL
CCF_BASE_URL="https://raw.githubusercontent.com/ccfddl/ccf-deadlines/main/conference"
CACHE="./ML_Big3_Countdown/ml_data.json"
TMP_DIR=$(mktemp -d)
YQ_PATH="/opt/homebrew/bin/yq"

# Conference definitions: category|filename|display_name
CONFERENCES=(
  "AI|aaai.yml|AAAI"
  "AI|cvpr.yml|CVPR"
  "AI|iclr.yml|ICLR"
  "DB|vldb.yml|VLDB"
)

# Update if older than 7 days or missing
if [ ! -f "$CACHE" ] || [ $(find "$CACHE" -mtime +7) ]; then
  echo "[]" > "$CACHE"  # Initialize empty array
  
  for conf_def in "${CONFERENCES[@]}"; do
    IFS='|' read -r category filename display_name <<< "$conf_def"
    
    # Fetch the conference YAML file
    conf_url="${CCF_BASE_URL}/${category}/${filename}"
    conf_file="${TMP_DIR}/${filename}"
    
    echo "Fetching $display_name from $conf_url..."
    if curl -s "$conf_url" -o "$conf_file"; then
      # Convert YAML to JSON and process
      if "$YQ_PATH" -o=json "$conf_file" > "${conf_file}.json" 2>/dev/null; then
        # Process the conference data
        jq --arg name "$display_name" '
          # CCF YAML files are arrays, take the first element
          .[0] as $conf |
          
          # Find the most recent conference year from confs array
          if $conf.confs then
            $conf.confs 
            | map(select(.year >= 2025))  # Focus on 2025+ for current relevance
            | sort_by(.year) | reverse
            | .[0] // empty
            | select(. != null)
            | {
                name: $name,
                year: .year,
                deadline: (
                  # Look for abstract_deadline first, then regular deadline
                  if .timeline then
                    (.timeline[0].abstract_deadline // .timeline[0].deadline)
                  else
                    .deadline // empty
                  end
                ),
                date: .date,
                place: .place,
                timezone: (.timezone // "UTC"),
                source: "CCF"
              }
            | select(.deadline != null)
          else
            empty
          end
        ' "${conf_file}.json" > "${TMP_DIR}/${display_name}.json" 2>/dev/null
        
        # Only merge if the JSON file has content and is not empty
        if [ -s "${TMP_DIR}/${display_name}.json" ]; then
          # Read the current cache and the new conference data, then combine them
          jq -s '.[0] + [.[1]]' "$CACHE" "${TMP_DIR}/${display_name}.json" > "${TMP_DIR}/merged.json" 2>/dev/null
          if [ -s "${TMP_DIR}/merged.json" ]; then
            mv "${TMP_DIR}/merged.json" "$CACHE"
            echo "✓ Successfully processed $display_name"
          fi
        else
          echo "Warning: No recent conference data found for $display_name"
        fi
      else
        echo "Warning: Failed to parse YAML for $display_name"
      fi
    else
      echo "Warning: Failed to fetch $display_name"
    fi
  done
  
  # Final cleanup - remove any null entries and sort by deadline  
  if [ -f "$CACHE" ]; then
    jq '[.[] | select(. != null)] | sort_by(.deadline)' "$CACHE" > "${TMP_DIR}/final.json" 2>/dev/null
    if [ -s "${TMP_DIR}/final.json" ]; then
      mv "${TMP_DIR}/final.json" "$CACHE"
    fi
  fi
fi

# Clean up temporary directory
rm -rf "$TMP_DIR"

# Output the cached data
cat "$CACHE"