#!/bin/bash

# Any lines containing this marker will be removed from the crontab
MARKER="get_metrics.sh"

# Backup existing crontab
crontab -l > current_cron.bak 2>/dev/null

# Remove lines containing the marker
grep -v "$MARKER" current_cron.bak > new_cron.bak

# Apply the updated crontab
crontab new_cron.bak

# Rm temp files
rm current_cron.bak new_cron.bak

echo "Crontab entries related to '$MARKER' have been removed."