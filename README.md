[![GHCR Build Status](https://github.com/kaytwo/docker-redis/actions/workflows/ghcr.yml/badge.svg?branch=main)](https://github.com/kaytwo/docker-redis/actions/workflows/ghcr.yml)
[![Docker Hub Build Status](https://github.com/kaytwo/docker-redis/actions/workflows/dockerhub.yml/badge.svg?branch=main)](https://github.com/kaytwo/docker-redis/actions/workflows/dockerhub.yml)

# Redis Docker Image with Self-Signed SSL Certs

This is the same as the [postgres
version](https://github.com/infrastructure-as-code/docker-postgres), but changed
to work for redis.

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
every push to the `main` branch of this repo. The provenance can be confirmed
using the `[gh attestation
verify](https://cli.github.com/manual/gh_attestation_verify)` command. Weekly
builds are kicked off on Saturdays at 00:30 UTC so that we get all the upstream
updates to the `redis` image.

## Multiarch

Images are built for the following architecture.

1. amd64
1. arm32v6
1. arm64v8

## Images

| Registry Name | Image Name |
|---------------|------------|
| GitHub Container Registry | `ghcr.io/kaytwo/redis` |
| Docker Hub | `kaytwo/redis` |

## Supported Tags and Respective Dockerfiles

* [`7`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile), [`7-alpine`](https://github.com/kaytwo/docker-redis/blob/main/alpine.Dockerfile)
* `latest` is equivalent to [`7`](https://github.com/kaytwo/docker-redis/blob/main/debian.Dockerfile).

## Usage

Starting a container.

```
docker run --rm -p 6379:6379 ghcr.io/kaytwo/redis
```

Connecting to a container.

```
redis-cli --tls --insecure
```

## Environment Variables

Since this image is extended from the official Redis images, it also has the same basic funcationality as the official images, so please review [the instructions from the official image](https://github.com/docker-library/docs/blob/master/redis/README.md) as well.

## Security Note

Self-signed SSL certifications are generated when a container is started for the first time (so that at least we don't all have the same certificates).


Please make sure you understand the security implications of using self-signed certificates of you use this for anything other than dev or test purposes.
