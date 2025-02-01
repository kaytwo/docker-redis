[![GHCR Build Status](https://github.com/kaytwo/docker-redis/actions/workflows/ghcr.yml/badge.svg?branch=main)](https://github.com/kaytwo/docker-redis/actions/workflows/ghcr.yml)
[![Docker Hub Build Status](https://github.com/kaytwo/docker-redis/actions/workflows/dockerhub.yml/badge.svg?branch=main)](https://github.com/kaytwo/docker-redis/actions/workflows/dockerhub.yml)

# Redis Docker Image with Self-Signed SSL Certs

This is the same as the [postgres
version](https://github.com/infrastructure-as-code/docker-postgres), but changed
to work for redis. Haven't updated the readme yet.

The [official Redis image](https://hub.docker.com/_/redis) comes without
any SSL certificates, leaving users to create the functionality for themselves.
This image strives to provide that missing functionality by using self-signed
SSL certificates. It is available on both GitHub Container Register (`ghcr.io`)
and Docker Hub (`hub.docker.com`).

This container overwrites the entrypoint for the standard redis container and
uses the config file stored at `/etc/redis.conf`. If you want to change any of
the configuration, mount your own `redis.conf` as a volume at that path and it
will be used for everything except the TLS configuration.

Unfortunately because I don't want to parse the redis command line, this means
that you can't specify any configuration as part of the command arguments - you
need to either use the config file or environment variables.

If you want to persist your ssl keys for whatever reason, you can mount the
directory `/etc/ssl/private`, and key generation will be skipped if they're
already in there.

# Postgres Docker Image with Self-Signed SSL Certs

## Automated Builds

In order to ensure the provenance of the images, all images are automatically
built and pushed by [GitHub Actions](https://github.com/features/actions) with
every push to the `main` branch of this repo. Weekly builds are kicked off on
Saturdays at 00:30 UTC so that we get all the upstream updates to the `postgres`
image.

## Multiarch

Images are built for the following architecture.

1. amd64
1. arm32v6
1. arm64v8

## Images

| Registry Name | Image Name |
|---------------|------------|
| GitHub Container Registry | `ghcr.io/infrastructure-as-code/postgres` |
| Docker Hub | `infrastructureascode/postgres` |

## Supported Tags and Respective Dockerfiles

* [`13`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile), [`13-alpine`](https://github.com/kaytwo/docker-redis/blob/main/alpine.Dockerfile)
* [`14`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile), [`14-alpine`](https://github.com/kaytwo/docker-redis/blob/main/alpine.Dockerfile)
* [`15`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile), [`15-alpine`](https://github.com/kaytwo/docker-redis/blob/main/alpine.Dockerfile)
* [`16`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile), [`16-alpine`](https://github.com/kaytwo/docker-redis/blob/main/alpine.Dockerfile)
* [`17`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile), [`17-alpine`](https://github.com/kaytwo/docker-redis/blob/main/alpine.Dockerfile)


## Usage

Starting a container.

```
docker run --rm -it \
  -e POSTGRES_PASSWORD=password \
  ghcr.io/infrastructure-as-code/postgres:15-alpine
```

## Environment Variables

Since this image is extended from the official Postgresql images, it also has the same basic funcationality as the official images, so please review [the instructions from the official image](https://github.com/docker-library/docs/blob/master/postgres/README.md) as well.

Additionally, the following environment variables provide a little bit of control of the self-signed SSL certificates.

| Environment Variable | Default Value | Description |
|----------------------|---------------|-------------|
| `SSL_DOMAIN`         | `pg.local`    | The domain used in the self-signed SSL certificate |
| `SSL_DAYS`           | 3650          | The number of days the self-signed SSL certificates are valid for |
| `SSL_ONLY`           | `true`        | Should all connections be SSL-only? |


## Security Note

Self-signed SSL certifications are generated when a container is started for the first time (so that at least we don't all have the same certificates).


Please make sure you understand the security implications of using self-signed certificates of you use this for anything other than dev or test purposes.  The [Postgresql libpq-ssl](https://www.postgresql.org/docs/11/libpq-ssl.html#LIBPQ-SSL-PROTECTION) page has a nice table describing the SSL modes that you should review.


## References

1. https://gist.github.com/mrw34/c97bb03ea1054afb551886ffc8b63c3b
1. https://www.postgresql.org/docs/11/ssl-tcp.html
1. https://www.postgresql.org/docs/11/libpq-ssl.html#LIBPQ-SSL-PROTECTION
