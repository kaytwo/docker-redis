#!/bin/sh
set -eu


SSL_DOMAIN=${SSL_DOMAIN:="redis.local"}
SSL_DAYS=${SSL_DAYS:=3650}
SSL_ONLY=${SSL_ONLY:="true"}
KEY_DIR=${KEY_DIR:="/etc/ssl/private"}

if [ ! -f "${KEY_DIR}/server.crt" ] || [ ! -f "${KEY_DIR}/server.key" ]; then

mkdir -p "${KEY_DIR}"

echo "Generating self-signed SSL certificates valid for ${SSL_DAYS} days with ${SSL_DOMAIN} domain"
openssl req -new -x509 -days ${SSL_DAYS} -nodes -text \
  -out "${KEY_DIR}/server.crt" \
  -keyout "${KEY_DIR}/server.key" \
  -subj "/CN=${SSL_DOMAIN}"
chown redis:redis \
  "${KEY_DIR}/server.crt" \
  "${KEY_DIR}/server.key"
chmod og-rwx "${KEY_DIR}/server.key"

echo "Updating redis.conf with SSL configurations"
echo "

tls-port 6379
port 0
tls-auth-clients no

tls-cert-file ${KEY_DIR}/server.crt
tls-key-file ${KEY_DIR}/server.key
" >> "/etc/redis.conf"
fi

exec redis-server /etc/redis.conf
