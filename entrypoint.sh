#!/bin/bash
set -e

# Default value in case the user does not define one
CRON_SCHEDULE=${CRON_SCHEDULE:-"0 0 * * *"}

echo "Using CRON schedule: $CRON_SCHEDULE"

# Create cron job
echo "$CRON_SCHEDULE root /app/script.sh >> /proc/1/fd/1 2>&1" > /etc/cron.d/db-sync
echo "" >> /etc/cron.d/db-sync

chmod 0644 /etc/cron.d/db-sync

touch /var/log/db-sync.log

# Start cron in foreground
cron -f
