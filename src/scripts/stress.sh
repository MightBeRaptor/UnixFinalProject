#!/bin/bash

# Get all container IDs for the web service
containers=$(docker ps --filter "name=mystack_web" --format "{{.ID}}")

for container in $containers; do
    # Get number of CPUs inside the container
    container_cpus=$(docker exec "$container" nproc)

    # Run stress test inside container
    docker exec "$container" stress-ng --cpu "$container_cpus" -t 60s