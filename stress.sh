#!/bin/bash

while true; do
	stress-ng --cpu $(nproc) --t $(( (RANDOM % 180) + 30))
done