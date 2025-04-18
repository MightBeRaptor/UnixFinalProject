#!/bin/bash

containers=$(docker ps --filter "name=mystack_web" --format "{{.ID}}")

for container in $containers; do
    echo "Starting stress-ng in $container"
    docker exec "$container" sh -c "stress-ng --cpu \$(nproc) -t 60s" &
done

wait
echo "Stress test completed."