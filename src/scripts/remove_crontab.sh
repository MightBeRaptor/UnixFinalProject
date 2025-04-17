#!/bin/bash

# List of substrings to search for and remove from crontab
MARKERS=("get_metrics.sh" "scale.sh")

# Backup existing crontab
crontab -l > current_cron.bak 2>/dev/null

# Join markers into a single regex pattern separated by "|"
PATTERN=$(IFS="|"; echo "${MARKERS[*]}")

# Remove lines that match any marker
grep -Ev "$PATTERN" current_cron.bak > new_cron.bak

# Apply the updated crontab
crontab new_cron.bak

# Cleanup
rm current_cron.bak new_cron.bak

echo "Crontab entries containing any of the specified markers have been removed."