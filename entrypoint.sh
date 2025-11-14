#!/bin/bash
set -e

# Default value in case the user does not define one
CRON_SCHEDULE=${CRON_SCHEDULE:-"0 0 * * *"}

echo "Using CRON schedule: $CRON_SCHEDULE"

# Create cron job
{
  echo "SRC_HOST=$SRC_HOST"
  echo "SRC_USER=$SRC_USER"
  echo "SRC_PASS=$SRC_PASS"
  echo "SRC_DB=$SRC_DB"
  echo "DST_HOST=$DST_HOST"
  echo "DST_USER=$DST_USER"
  echo "DST_PASS=$DST_PASS"
  echo "DST_DB=$DST_DB"
  echo "TABLES=$TABLES"
  echo ""
  echo "$CRON_SCHEDULE root /app/script.sh >> /proc/1/fd/1 2>&1"
  echo ""
} > /etc/cron.d/db-sync

chmod 0644 /etc/cron.d/db-sync

touch /var/log/db-sync.log

# Start cron in foreground
cron -f
