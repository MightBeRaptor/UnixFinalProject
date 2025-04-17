#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found."
    exit 1
fi

# Ensure REPO_PATH is set
if [ -z "$REPO_PATH" ]; then
    echo "REPO_PATH variable is not set in .env."
    exit 1
fi

# Define script paths
METRICS_SCRIPT="$REPO_PATH/src/scripts/get_metrics.sh"
SCALE_SCRIPT="$REPO_PATH/src/scripts/scale.sh"

CRON_METRICS="*/2 * * * * /bin/bash $METRICS_SCRIPT \"$REPO_PATH\""
CRON_SCALE="*/2 * * * * /bin/bash $SCALE_SCRIPT \"$REPO_PATH\""

# Backup current crontab if it exists
CRONTAB_CONTENT=$(crontab -l 2>/dev/null || true)

# Initialize a variable to hold new entries
NEW_CRON="$CRONTAB_CONTENT"

# Add metrics cron line if not already present
if ! echo "$CRONTAB_CONTENT" | grep -Fq "$CRON_METRICS"; then
    NEW_CRON="${NEW_CRON}"$'\n'"$CRON_METRICS"
    echo "Added metrics cron job."
else
    echo "Metrics cron job already exists."
fi

# Add scale cron line if not already present
if ! echo "$CRONTAB_CONTENT" | grep -Fq "$CRON_SCALE"; then
    NEW_CRON="${NEW_CRON}"$'\n'"$CRON_SCALE"
    echo "Added scale cron job."
else
    echo "Scale cron job already exists."
fi

# Install updated crontab if anything changed
if [ "$NEW_CRON" != "$CRONTAB_CONTENT" ]; then
    echo "$NEW_CRON" | crontab -
    echo "Crontab updated."
else
    echo "No changes made to crontab."
fi
echo "Crontab updated with job to run every 2 minutes."