default: docker_build

DOCKER_IMAGE ?= pashaliyski/vmware-task
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
GIT_VERSION ?= $(shell git rev-parse --short HEAD)

# If git branch is master set docker image tag to 'latest'
ifeq ($(GIT_BRANCH), main)
	DOCKER_TAG = latest
else
	DOCKER_TAG = $(GIT_BRANCH)
endif

docker_build:
	@docker build \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  --build-arg VERSION=${GIT_VERSION} \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) \
	  -t $(DOCKER_IMAGE):$(GIT_VERSION) \
	  -f ./Dockerfile \
	  .

docker_push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):$(GIT_VERSION)

test:
	docker run -p 8000:8000 --rm $(DOCKER_IMAGE):$(DOCKER_TAG)
