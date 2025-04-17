#!/bin/bash

# Ensure mystack is running
if ! docker stack ls | grep -q mystack; then
  echo "Stack 'mystack' is not running. Exiting."
  exit 1
fi

# Get all container IDs for the web service
containers=$(docker ps --filter "name=mystack_web" --format "{{.ID}}")

total=0
count=0

for container in $containers; do
    # Get CPU usage for each container
    cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container" | cut -d'.' -f1 | tr -d '%')
    
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

# data dir will be created by scale.sh
# output to file
echo "$avg" > data/metrics.txt