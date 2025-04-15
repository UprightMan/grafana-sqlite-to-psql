FROM dimitri/pgloader:latest

LABEL maintainer="jelic.leon@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/dimitri/pgloader"
LABEL org.opencontainers.image.description="Built on top of dimitri/pgloader for SQLite to PostgreSQL migration of Grafana's databse"

USER root

RUN apt-get update && \
    apt-get install -y postgresql-client netcat-openbsd

COPY pgloader.load.template /data/pgloader.load.template
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]