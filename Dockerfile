FROM dimitri/pgloader:latest

USER root

RUN apt-get update && \
    apt-get install -y postgresql-client netcat-openbsd

COPY pgloader.load.template /data/pgloader.load.template
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]