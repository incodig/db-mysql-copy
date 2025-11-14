#!/bin/bash
set -e

# Default value in case the user does not define one
CRON_SCHEDULE=${CRON_SCHEDULE:-"0 6 * * *"}

echo "Using CRON schedule: $CRON_SCHEDULE"

# Create cron job
echo "$CRON_SCHEDULE /app/script.sh 2>&1" > /etc/cron.d/db-sync
echo "" >> /etc/cron.d/db-sync

chmod 0644 /etc/cron.d/db-sync

touch /var/log/db-sync.log

# Start cron in foreground
cron -f
