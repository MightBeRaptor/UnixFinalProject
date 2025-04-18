#!/bin/bash

# Get all container IDs for the web service
containers=$(docker ps --filter "name=mystack_web" --format "{{.ID}}")

for container in $containers; do
    # Get CPU usage for each container
    docker exec $container stress-ng --cpu $(nproc) -t 60s