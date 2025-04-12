#!/bin/bash

docker-compose down

docker-compose up --build --scale web=3 -d