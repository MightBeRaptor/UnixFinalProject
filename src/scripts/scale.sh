#!/bin/bash

# Ensure REPO_PATH is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <REPO_PATH>"
  exit 1
fi

# Ensure stack is running
if ! docker stack ls | grep -q mystack; then
    echo "Stack 'mystack' is not running. Exiting."
    exit 1
fi

# Read average CPU usage
if [ ! -f $REPO_PATH/data/metrics.txt ]; then
    echo "No metrics found."
    exit 1
fi

avg=$(cat $REPO_PATH/data/metrics.txt)

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

echo "Successfully autoscaled to $num_replicas replicas."
exit 1 # logging purposes for now