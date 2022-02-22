.PHONY: run

IMAGE := ghcr.io/m-shibuya9/alpine-deploy-azure:0.18.0

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -it $(IMAGE) bash
