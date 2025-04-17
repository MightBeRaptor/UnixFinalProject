#!/bin/bash

docker stack rm mystack # Remove stack if it exists

sleep 5

docker build -t mywebapp:latest -f ./src/app/Dockerfile.app ./src/app # Build image

sleep 5

docker stack deploy -c stack.yml mystack # Start stack