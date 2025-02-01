image = ghcr.io/kaytwo/redis
versions = \
	debian \
	alpine

alpine_tags = \
	7-alpine

debian_tags = \
	7

all: $(alpine_tags) $(debian_tags)

$(alpine_tags):
	make build distro=alpine version=$@

$(debian_tags):
	make build distro=debian version=$@

build:
	$(eval tag = $(image):$(version))
	docker build --rm \
		--tag $(tag) \
		--file $(distro).Dockerfile \
		--build-arg base_image=public.ecr.aws/docker/library/redis:$(version) \
		.
	IMAGE=$(tag) docker compose -f docker-compose.test.yml run sut
	IMAGE=$(tag) docker compose -f docker-compose.test.yml down

.PHONY: $(alpine_tags) $(debian_tags)
