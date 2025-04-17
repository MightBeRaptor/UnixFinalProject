#!/bin/bash

# Wait 30 seconds for get_metrics.sh to finish
sleep 30

# Ensure REPO_PATH is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <REPO_PATH>"
  exit 2
fi

REPO_PATH="$1"

# Ensure stack is running
if ! docker stack ls | grep -q mystack; then
    echo "Stack 'mystack' is not running. Exiting."
    exit 3
fi

METRICS_FILE="$REPO_PATH/data/metrics.txt"

# Check if the metrics file exists
if [ ! -f "$METRICS_FILE" ]; then
    echo "No metrics file found at $METRICS_FILE"
    exit 4
fi

# Read and validate average CPU usage
avg=$(cat "$METRICS_FILE")
if ! [[ "$avg" =~ ^[0-9]+$ ]]; then
    echo "Invalid CPU usage value: $avg"
    exit 5
fi

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
fi

if [ "$num_replicas" -eq 0 ]; then
    output_str="No scaling action taken. CPU usage of $avg is within acceptable range."
else
    output_str="Successfully autoscaled to $num_replicas replicas due to an average CPU usage of $avg."
fi

# Log output
echo "$output_str" > "$REPO_PATH/logs/scale.log"