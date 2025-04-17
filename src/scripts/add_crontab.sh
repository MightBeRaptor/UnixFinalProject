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
CRON_LINE="*/2 * * * * /bin/bash $METRICS_SCRIPT $REPO_PATH"

# Backup current crontab if it exists
CRONTAB_CONTENT=$(crontab -l 2>/dev/null)

# Check if the cron line already exists
echo "$CRONTAB_CONTENT" | grep -F "$CRON_LINE" >/dev/null
if [ $? -eq 0 ]; then # make sure previous command was successful
    echo "Crontab already contains the required job."
    exit 0
fi

# Add the new cron line
(
    echo "$CRONTAB_CONTENT"
    echo "$CRON_LINE"
) | crontab -

echo "Crontab updated with job to run every 2 minutes."