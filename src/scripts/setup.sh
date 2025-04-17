#!/bin/bash

sudo usermod -aG docker $USER # Add user to docker group so sudo prefix isn't needed

mkdir -p data  # Ensure the data directory exists

docker swarm init