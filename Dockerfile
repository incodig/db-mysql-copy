FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y mysql-client cron && \
    mkdir -p /app/dumps

COPY script.sh /app/script.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /app/script.sh && chmod +x /entrypoint.sh

ENV CRON_SCHEDULE="0 0 * * *"

ENTRYPOINT ["/entrypoint.sh"]
