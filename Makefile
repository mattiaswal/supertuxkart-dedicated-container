.PHONY: build archive clean help

IMAGE_NAME := mattiaswal/supertuxkart
IMAGE_TAG := latest
ARCHIVE_NAME := supertuxkart-oci.tar
PLATFORMS := linux/aarch64

all: ${ARCHIVE_NAME}

build:
        @echo "Building Docker image $(IMAGE_NAME):$(IMAGE_TAG) for multiple platforms..."
        docker buildx build --platform $(PLATFORMS) -t $(IMAGE_NAME):$(IMAGE_TAG) -f Dockerfile . --load

${ARCHIVE_NAME}: build
        @echo "Creating OCI archive $(ARCHIVE_NAME)..."
        docker save $(IMAGE_NAME):$(IMAGE_TAG) -o $(ARCHIVE_NAME)
        @echo "OCI archive created: $(ARCHIVE_NAME)"

clean:
        @echo "Removing Docker image and OCI archive..."
        -docker rmi $(IMAGE_NAME):$(IMAGE_TAG)
        -rm -f $(ARCHIVE_NAME)
        @echo "Cleanup complete"


