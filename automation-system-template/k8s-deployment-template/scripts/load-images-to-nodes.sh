#!/bin/bash

# Generic script to load Docker images to Kubernetes nodes
# Usage: ./load-images-to-nodes.sh [method] [image:tag...]
# Methods: kind, minikube, manual, registry

set -e

# Configuration
METHOD=${1:-"manual"}
shift
IMAGES=("$@")

# If no images specified, use defaults from environment
if [ ${#IMAGES[@]} -eq 0 ]; then
    IMAGE_NAME="${IMAGE_NAME:-my-app}"
    IMAGE_TAG="${IMAGE_TAG:-latest}"
    IMAGES=("${IMAGE_NAME}:${IMAGE_TAG}")
fi

echo "Loading images to Kubernetes nodes using method: $METHOD"
echo "Images: ${IMAGES[*]}"
echo ""

case $METHOD in
  kind)
    echo "Loading images to kind cluster..."
    for image in "${IMAGES[@]}"; do
        echo "  Loading $image..."
        kind load docker-image "$image"
    done
    echo "✓ Images loaded successfully to kind cluster!"
    ;;

  minikube)
    echo "Loading images to minikube..."
    for image in "${IMAGES[@]}"; do
        echo "  Loading $image..."
        minikube image load "$image"
    done
    echo "✓ Images loaded successfully to minikube!"
    ;;

  registry)
    echo "Tagging and pushing images to private registry..."

    # Get registry URL from environment or prompt
    if [ -z "$REGISTRY_URL" ]; then
        read -p "Enter registry URL (e.g., registry.example.com): " REGISTRY_URL
    fi

    for image in "${IMAGES[@]}"; do
        echo "  Processing $image..."
        # Tag for registry
        registry_image="$REGISTRY_URL/$image"
        docker tag "$image" "$registry_image"
        echo "  Pushing $registry_image..."
        docker push "$registry_image"
    done

    echo ""
    echo "✓ Images pushed to registry!"
    echo ""
    echo "Update your manifests to use registry images:"
    for image in "${IMAGES[@]}"; do
        echo "  $REGISTRY_URL/$image"
    done
    ;;

  manual)
    echo "Saving images to tar files..."

    for image in "${IMAGES[@]}"; do
        # Replace : and / with - for filename
        filename="${image//[\/:]/\-}.tar.gz"
        echo "  Saving $image to $filename..."
        docker save "$image" | gzip > "$filename"
    done

    echo ""
    echo "✓ Images saved!"
    echo ""
    echo "Now copy these files to each Kubernetes node and load them:"
    echo ""

    for image in "${IMAGES[@]}"; do
        filename="${image//[\/:]/\-}.tar.gz"
        echo "  # For $image:"
        echo "  scp $filename user@node:/tmp/"
        echo "  ssh user@node 'docker load < /tmp/$filename'"
        echo ""
    done

    echo "Repeat for all nodes in your cluster."
    ;;

  *)
    echo "Unknown method: $METHOD"
    echo ""
    echo "Usage: $0 [method] [image:tag...]"
    echo ""
    echo "Methods:"
    echo "  kind       - Load images to kind cluster"
    echo "  minikube   - Load images to minikube"
    echo "  registry   - Tag and push to private registry"
    echo "  manual     - Save to tar files for manual distribution"
    echo ""
    echo "Examples:"
    echo "  $0 kind my-app:latest"
    echo "  $0 minikube my-app:v1.0 my-db:latest"
    echo "  $0 registry my-app:latest"
    echo "  $0 manual my-app:latest another-service:v2.0"
    exit 1
    ;;
esac

echo ""
echo "Image loading complete!"
