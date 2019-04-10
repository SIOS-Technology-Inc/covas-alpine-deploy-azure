.PHONY: run

IMAGE := instoll/alpine-deploy-azure:latest

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -it $(IMAGE) bash
