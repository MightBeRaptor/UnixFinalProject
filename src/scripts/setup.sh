#!/bin/bash

sudo usermod -aG docker $USER # Add user to docker group so sudo prefix isn't needed

docker swarm init