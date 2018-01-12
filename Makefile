IMAGE_NAME ?= delve

# Where to push the docker image
REGISTRY ?= aidminutes

# This version-strategy uses git tags to set the version string
VERSION := $(shell git describe --tags --always --dirty)

IMAGE := "$(REGISTRY)/$(IMAGE_NAME)"

all: build

all-build: build
all-container: container
all-push: push

build: container

shell: container
	@echo "launching a shell in the containterized build environment"
	@docker run                    \
		-ti                    \
		--rm                   \
		-u $$(id -u):$$(id -g) \
		$(IMAGE):$(VERSION)    \
		/bin/sh $(CMD)

version:
	@echo $(VERSION)

container: .container container-name
.container:
	@docker build -t $(IMAGE):$(VERSION) .

container-name:
	@echo "container: $(IMAGE):$(VERSION)"

push: .push push-name
.push:
	ifeq ($(findstring gcr.io,$(REGISTRY)),gcr.io)
		@gcloud docker -- push $(IMAGE):$(VERSION)
	else
		@docker push $(IMAGE):$(VERSION)
	endif

push-name:
	@echo "pushed: $(IMAGE):$(VERSION)"

clean:
	@echo "cleaned"

