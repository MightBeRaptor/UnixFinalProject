#!/bin/bash

# Ensure REPO_PATH is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <REPO_PATH>"
  exit 1
fi

REPO_PATH="$1"
METRICS_FILE="$REPO_PATH/data/metrics.txt"

# Ensure mystack is running
if ! docker stack ls | grep -q mystack; then
  echo "Stack 'mystack' is not running. Exiting."
  exit 1
fi

mkdir -p "$REPO_PATH/data"  # Ensure data directory exists
touch "$METRICS_FILE"       # Create the metrics file if it doesn't exist

# Get all container IDs for the web service
containers=$(docker ps --filter "name=mystack_web" --format "{{.ID}}")

total=0
count=0

for container in $containers; do
    # Get CPU usage for each container
    cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container" | cut -d'.' -f1 | tr -d '%') # reformat i.e. 5.01% to 5

    # Ensure its a valid number, add to total
    if [[ "$cpu" =~ ^[0-9]+$ ]]; then
        total=$((total + cpu))
        count=$((count + 1))
    fi
done

# Average the cpu usage
if [ "$count" -gt 0 ]; then
    avg=$((total / count))
else
    avg=0
fi

# Output to metrics file
echo "$avg" > "$METRICS_FILE"

# Run scale.sh
bash "$REPO_PATH/src/scripts/scale.sh \"$REPO_PATH\""
if [ $? -ne 0 ]; then
    echo "Failed scale.sh"
    exit 1
fi