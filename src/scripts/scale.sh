#!/bin/bash

# Ensure stack is running
if ! docker stack ls | grep -q mystack; then
    echo "Stack 'mystack' is not running. Exiting."
    exit 1
fi

# Read average CPU usage
if [ ! -f data/metrics.txt ]; then
    echo "No metrics found."
    exit 1
fi

avg=$(cat data/metrics.txt)

# Apply scaling logic
if [ "$avg" -gt 70 ]; then
    docker service scale mystack_web=6
elif [ "$avg" -gt 60 ]; then
    docker service scale mystack_web=5
elif [ "$avg" -gt 50 ]; then
    docker service scale mystack_web=4
elif [ "$avg" -gt 40 ]; then
    docker service scale mystack_web=3
else
    echo "CPU usage ${avg}% within acceptable range. No scaling needed."
fi