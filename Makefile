.PHONY: build archive clean help

IMAGE_NAME := mattiaswal/supertuxkart-dedicated
IMAGE_TAG := latest
ARCHIVE_NAME := supertuxkart-dedicated-oci.tar
PLATFORMS := linux/aarch64,linux/amd64

all: build

build:
	@echo "Building Docker image $(IMAGE_NAME):$(IMAGE_TAG) for multiple platforms..."
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_NAME):$(IMAGE_TAG) -f Dockerfile . --push

${ARCHIVE_NAME}: build
	@echo "Creating OCI archive $(ARCHIVE_NAME)..."
	docker save $(IMAGE_NAME):$(IMAGE_TAG) -o $(ARCHIVE_NAME)
	@echo "OCI archive created: $(ARCHIVE_NAME)"

clean:
	@echo "Removing Docker image and OCI archive..."
	-docker rmi $(IMAGE_NAME):$(IMAGE_TAG)
	-rm -f $(ARCHIVE_NAME)
	@echo "Cleanup complete"
