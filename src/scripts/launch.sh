#!/bin/bash

docker-compose down

docker build -t mywebapp:latest -f ./src/app/Dockerfile.app ./src/app # Build image

docker-compose up --build --scale web=3 -d