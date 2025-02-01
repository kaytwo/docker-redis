ARG base_image
FROM ${base_image:-redis:alpine}

RUN \
  apk add --no-cache \
    openssl
COPY redis-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/redis-entrypoint.sh"]
