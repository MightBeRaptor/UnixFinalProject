#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found. Please create it using .env.example then rerun setup.sh"
    exit 1
fi

sudo usermod -aG docker $USER # Add user to docker group so sudo prefix isn't needed

mkdir -p data  # Ensure the data directory exists

docker swarm init