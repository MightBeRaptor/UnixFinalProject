#!/bin/bash

stress-ng --cpu $(nproc) -t 5m
