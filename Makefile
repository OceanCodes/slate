.PHONY: mage image-branch push push-branch

all: image

SHELL := /bin/bash
IMAGE_NAME = codeocean/slate
REGISTRY ?= 524950183868.dkr.ecr.us-east-1.amazonaws.com
TAG ?= $(shell ./make-tag.sh)
BRANCH ?= $(CIRCLE_BRANCH)

image:
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(REGISTRY)/$(IMAGE_NAME):latest
	if [ -n "$(TAG)" ]; then docker tag $(IMAGE_NAME):latest $(REGISTRY)/$(IMAGE_NAME):$(TAG); fi

image-branch:
	if [ -n "$(BRANCH)" ]; then \
		docker build -t $(REGISTRY)/$(IMAGE_NAME):$(BRANCH) .; \
	fi

push:
	if [ -n "$(TAG)" ]; then \
		`aws ecr get-login --region us-east-1`; \
		docker push $(REGISTRY)/$(IMAGE_NAME):latest | cat; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG) | cat; \
	fi

push-branch:
	if [ -n "$(BRANCH)" ]; then \
		`aws ecr get-login --region us-east-1`; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$(BRANCH) | cat; \
	fi

serve:
	docker run --rm -it -p 4567:4567 -v `pwd`/source:/usr/src/app/source $(REGISTRY)/$(IMAGE_NAME)

build:
	docker run --rm -it -v `pwd`/source:/usr/src/app/source -v `pwd`/build:/usr/src/app/build $(REGISTRY)/$(IMAGE_NAME) bundle exec middleman build --clean
