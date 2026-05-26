#!/bin/sh
set -e

(
  cd tls/certs \
    && docker run --rm -v .:/certs -it nginx openssl req -new -newkey rsa:4096 -x509 -days 365 -subj /CN=flood-redis-tls -nodes -out certs/redis.pem -keyout certs/redis.key \
    && chmod 644 redis.key # Allow Redis containers to read the private key used for local development.
)