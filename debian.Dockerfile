ARG base_image
FROM ${base_image:-redis:latest}

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update -y && \
  apt-get install -y -qq \
    openssl && \
  apt-get clean autoclean -y && \
  apt-get autoremove --yes && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
  unset DEBIAN_FRONTEND
COPY redis-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/redis-entrypoint.sh"]
