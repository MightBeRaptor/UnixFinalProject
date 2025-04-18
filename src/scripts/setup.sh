#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found. Please create it using .env.example then rerun setup.sh"
    exit 1
fi

sudo usermod -aG docker $USER # Add user to docker group so sudo prefix isn't needed

sudo apt install -y stress-ng

mkdir -p data  # Ensure the data directory exists

mkdir -p logs  # Ensure the logs directory exists

docker swarm init
