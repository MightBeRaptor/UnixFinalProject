#!/bin/bash

docker stack rm mystack # Remove stack if it exists

docker build -t mywebapp:latest -f ./src/app/Dockerfile.app ./src/app # Build image

docker stack deploy -c stack.yml mystack # Start stack