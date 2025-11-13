#!/bin/bash
set -e

BACKUP_DIR="/app/dumps"
DATA_FILE="$BACKUP_DIR/data.sql"
STRUCT_FILE="$BACKUP_DIR/structure.sql"

mkdir -p "$BACKUP_DIR"
rm -f "$DATA_FILE" "$STRUCT_FILE"

date_msg=$(date)
echo "=== [$date_msg] Starting dump ==="

for table in $TABLES; do
  echo "Dumping structure of $table..."
  mysqldump -h "$SRC_HOST" -u "$SRC_USER" -p"$SRC_PASS" --no-data "$SRC_DB" "$table" >> "$STRUCT_FILE"

  echo "Dumping data of $table..."
  mysqldump -h "$SRC_HOST" -u "$SRC_USER" -p"$SRC_PASS" --no-create-info "$SRC_DB" "$table" >> "$DATA_FILE"
done

echo "=== Dumps created ==="

for table in $TABLES; do
  echo "Dropping table $table in destination..."
  mysql -h "$DST_HOST" -u "$DST_USER" -p"$DST_PASS" "$DST_DB" -e "DROP TABLE IF EXISTS $table;"
done

echo "Importing structure..."
mysql -h "$DST_HOST" -u "$DST_USER" -p"$DST_PASS" "$DST_DB" < "$STRUCT_FILE"

echo "Importing data..."
mysql -h "$DST_HOST" -u "$DST_USER" -p"$DST_PASS" "$DST_DB" < "$DATA_FILE"

echo "=== Process completed ==="
