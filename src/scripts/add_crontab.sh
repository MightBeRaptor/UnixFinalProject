#!/bin/bash

# Define script paths
COLLECT_SCRIPT="/home/master/UnixFinalProject/src/scripts/get_metrics.sh"
SCALE_SCRIPT="/home/master/UnixFinalProject/src/scripts/scale.sh"
CRON_LINE="*/2 * * * * /bin/bash $COLLECT_SCRIPT && /bin/bash $SCALE_SCRIPT"

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