#!/bin/bash

# Ensure REPO_PATH is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <REPO_PATH>"
  exit 1
fi

REPO_PATH="$1"

# Ensure stack is running
if ! docker stack ls | grep -q mystack; then
    echo "Stack 'mystack' is not running. Exiting."
    exit 1
fi

METRICS_FILE="$REPO_PATH/data/metrics.txt"

# Check if the metrics file exists
if [ ! -f "$METRICS_FILE" ]; then
    echo "No metrics file found at $METRICS_FILE"
    exit 1
fi

# Read and validate average CPU usage
avg=$(cat "$METRICS_FILE")

num_replicas=0

# Apply scaling logic
if [ "$avg" -gt 70 ]; then
    num_replicas=6
    docker service scale mystack_web=6
elif [ "$avg" -gt 60 ]; then
    num_replicas=5
    docker service scale mystack_web=5
elif [ "$avg" -gt 50 ]; then
    num_replicas=4
    docker service scale mystack_web=4
elif [ "$avg" -gt 40 ]; then
    num_replicas=3
    docker service scale mystack_web=3
else
    echo "CPU usage ${avg}% within acceptable range. No scaling needed."
fi

if [ "$num_replicas" -eq 0 ]; then
    echo "No scaling action taken due to an average CPU usage of $avg."
    exit 0
fi



output_str="Successfully autoscaled to $num_replicas replicas due to an average CPU usage of $avg."

# Log the output to logs/scale.log and echo to console
mkdir -p "$REPO_PATH/logs"  # Ensure logs directory exists
touch "$REPO_PATH/logs/scale.log" # create log file if it doesn't exist
echo "$output_str" | tee -a "$REPO_PATH/logs/scale.log" # append to log
echo "$output_str"