#!/bin/bash

# Generic Kubernetes Deployment Script
# Customize the variables below for your project

set -e

# ============================================
# CONFIGURATION - Customize these variables
# ============================================

APP_NAME="${APP_NAME:-my-app}"
NAMESPACE="${NAMESPACE:-$APP_NAME}"
IMAGE_NAME="${IMAGE_NAME:-$APP_NAME}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
BUILD_CONTEXT="${BUILD_CONTEXT:-.}"
MANIFESTS_DIR="${MANIFESTS_DIR:-./manifests}"

# ============================================
# Colors for output
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# Functions
# ============================================

print_header() {
    echo ""
    echo -e "${CYAN}=================================="
    echo "$1"
    echo -e "==================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

check_prerequisites() {
    print_step "Checking prerequisites..."

    if ! command -v kubectl &> /dev/null; then
        print_error "Error: kubectl is not installed"
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        print_error "Error: Docker is not installed"
        exit 1
    fi

    # Check cluster connection
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Error: Cannot connect to Kubernetes cluster"
        exit 1
    fi

    print_step "✓ All prerequisites met"
}

build_images() {
    print_step "Building Docker image: $IMAGE_NAME:$IMAGE_TAG"
    docker build -t "$IMAGE_NAME:$IMAGE_TAG" "$BUILD_CONTEXT"
    print_step "✓ Image built successfully"
}

load_images() {
    print_step "Loading images to cluster..."
    print_warning "Choose your method:"
    print_warning "  [1] kind cluster"
    print_warning "  [2] minikube cluster"
    print_warning "  [3] Skip (using private registry or manual load)"

    read -p "Enter choice [1-3]: " choice

    case $choice in
        1)
            kind load docker-image "$IMAGE_NAME:$IMAGE_TAG"
            print_step "✓ Images loaded to kind cluster"
            ;;
        2)
            minikube image load "$IMAGE_NAME:$IMAGE_TAG"
            print_step "✓ Images loaded to minikube"
            ;;
        3)
            print_warning "Skipping image load. Ensure images are available to your cluster."
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
}

deploy_manifests() {
    print_step "Deploying to Kubernetes..."

    # Check if using kustomize
    if [ -f "$MANIFESTS_DIR/kustomization.yaml" ]; then
        print_step "Using kustomize..."
        kubectl apply -k "$MANIFESTS_DIR"
    else
        print_step "Applying manifests directly..."
        kubectl apply -f "$MANIFESTS_DIR/namespace.yaml" 2>/dev/null || true
        kubectl apply -f "$MANIFESTS_DIR/configmap.yaml" 2>/dev/null || true
        kubectl apply -f "$MANIFESTS_DIR/deployment.yaml"
        kubectl apply -f "$MANIFESTS_DIR/service.yaml" 2>/dev/null || true
    fi

    print_step "✓ Manifests applied"
}

wait_for_deployment() {
    print_step "Waiting for deployment to be ready..."
    kubectl wait --for=condition=ready pod -l app="$APP_NAME" -n "$NAMESPACE" --timeout=300s || {
        print_error "Deployment did not become ready in time"
        print_warning "Check logs with: kubectl logs -l app=$APP_NAME -n $NAMESPACE"
        exit 1
    }
    print_step "✓ Deployment ready"
}

show_status() {
    print_header "Deployment Status"

    echo "Deployments:"
    kubectl get deployments -n "$NAMESPACE"
    echo ""

    echo "Services:"
    kubectl get services -n "$NAMESPACE"
    echo ""

    echo "Pods:"
    kubectl get pods -n "$NAMESPACE"
    echo ""
}

show_access_info() {
    print_header "Access Information"

    # Get NodePort if exists
    NODE_PORT=$(kubectl get svc -n "$NAMESPACE" -o jsonpath='{.items[?(@.spec.type=="NodePort")].spec.ports[0].nodePort}' 2>/dev/null)

    if [ -n "$NODE_PORT" ]; then
        NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
        echo -e "${GREEN}Service accessible at:${NC}"
        echo -e "  NodePort: ${CYAN}http://$NODE_IP:$NODE_PORT${NC}"
    else
        echo -e "${YELLOW}No NodePort service found${NC}"
        echo -e "Use port-forward: ${CYAN}kubectl port-forward -n $NAMESPACE svc/$APP_NAME-internal 8080:8080${NC}"
    fi

    echo ""
    print_warning "Useful commands:"
    echo "  Logs: kubectl logs -f -l app=$APP_NAME -n $NAMESPACE"
    echo "  Scale: kubectl scale deployment $APP_NAME --replicas=3 -n $NAMESPACE"
    echo "  Delete: kubectl delete namespace $NAMESPACE"
}

# ============================================
# Main execution
# ============================================

print_header "Kubernetes Deployment Script"
echo "App Name: $APP_NAME"
echo "Namespace: $NAMESPACE"
echo "Image: $IMAGE_NAME:$IMAGE_TAG"
echo ""

# Parse arguments
SKIP_BUILD=false
SKIP_LOAD=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --skip-load)
            SKIP_LOAD=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-build    Skip Docker image build"
            echo "  --skip-load     Skip loading images to cluster"
            echo "  --help          Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Execute deployment steps
check_prerequisites

if [ "$SKIP_BUILD" = false ]; then
    build_images
else
    print_warning "Skipping image build (--skip-build)"
fi

if [ "$SKIP_LOAD" = false ]; then
    load_images
else
    print_warning "Skipping image load (--skip-load)"
fi

deploy_manifests
wait_for_deployment
show_status
show_access_info

print_header "Deployment Complete!"
