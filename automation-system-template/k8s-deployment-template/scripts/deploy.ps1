# Generic Kubernetes Deployment Script (PowerShell)
# Customize the variables below for your project

param(
    [switch]$SkipBuild,
    [switch]$SkipLoad,
    [switch]$Help
)

# ============================================
# CONFIGURATION - Customize these variables
# ============================================

$APP_NAME = if ($env:APP_NAME) { $env:APP_NAME } else { "my-app" }
$NAMESPACE = if ($env:NAMESPACE) { $env:NAMESPACE } else { $APP_NAME }
$IMAGE_NAME = if ($env:IMAGE_NAME) { $env:IMAGE_NAME } else { $APP_NAME }
$IMAGE_TAG = if ($env:IMAGE_TAG) { $env:IMAGE_TAG } else { "latest" }
$BUILD_CONTEXT = if ($env:BUILD_CONTEXT) { $env:BUILD_CONTEXT } else { "." }
$MANIFESTS_DIR = if ($env:MANIFESTS_DIR) { $env:MANIFESTS_DIR } else { ".\manifests" }

$ErrorActionPreference = "Stop"

# ============================================
# Functions
# ============================================

function Print-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
}

function Print-Step {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Print-Warning {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

function Check-Prerequisites {
    Print-Step "Checking prerequisites..."

    if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
        Print-Error "Error: kubectl is not installed"
        exit 1
    }

    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Print-Error "Error: Docker is not installed"
        exit 1
    }

    # Check cluster connection
    try {
        kubectl cluster-info | Out-Null
    } catch {
        Print-Error "Error: Cannot connect to Kubernetes cluster"
        exit 1
    }

    Print-Step "✓ All prerequisites met"
}

function Build-Images {
    Print-Step "Building Docker image: $IMAGE_NAME:$IMAGE_TAG"
    docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" $BUILD_CONTEXT
    Print-Step "✓ Image built successfully"
}

function Load-Images {
    Print-Step "Loading images to cluster..."
    Print-Warning "Choose your method:"
    Print-Warning "  [1] kind cluster"
    Print-Warning "  [2] minikube cluster"
    Print-Warning "  [3] Skip (using private registry or manual load)"

    $choice = Read-Host "Enter choice [1-3]"

    switch ($choice) {
        "1" {
            kind load docker-image "${IMAGE_NAME}:${IMAGE_TAG}"
            Print-Step "✓ Images loaded to kind cluster"
        }
        "2" {
            minikube image load "${IMAGE_NAME}:${IMAGE_TAG}"
            Print-Step "✓ Images loaded to minikube"
        }
        "3" {
            Print-Warning "Skipping image load. Ensure images are available to your cluster."
        }
        default {
            Print-Error "Invalid choice"
            exit 1
        }
    }
}

function Deploy-Manifests {
    Print-Step "Deploying to Kubernetes..."

    # Check if using kustomize
    if (Test-Path "$MANIFESTS_DIR\kustomization.yaml") {
        Print-Step "Using kustomize..."
        kubectl apply -k $MANIFESTS_DIR
    } else {
        Print-Step "Applying manifests directly..."
        kubectl apply -f "$MANIFESTS_DIR\namespace.yaml" 2>$null
        kubectl apply -f "$MANIFESTS_DIR\configmap.yaml" 2>$null
        kubectl apply -f "$MANIFESTS_DIR\deployment.yaml"
        kubectl apply -f "$MANIFESTS_DIR\service.yaml" 2>$null
    }

    Print-Step "✓ Manifests applied"
}

function Wait-ForDeployment {
    Print-Step "Waiting for deployment to be ready..."
    try {
        kubectl wait --for=condition=ready pod -l app=$APP_NAME -n $NAMESPACE --timeout=300s
        Print-Step "✓ Deployment ready"
    } catch {
        Print-Error "Deployment did not become ready in time"
        Print-Warning "Check logs with: kubectl logs -l app=$APP_NAME -n $NAMESPACE"
        exit 1
    }
}

function Show-Status {
    Print-Header "Deployment Status"

    Write-Host "Deployments:"
    kubectl get deployments -n $NAMESPACE
    Write-Host ""

    Write-Host "Services:"
    kubectl get services -n $NAMESPACE
    Write-Host ""

    Write-Host "Pods:"
    kubectl get pods -n $NAMESPACE
    Write-Host ""
}

function Show-AccessInfo {
    Print-Header "Access Information"

    # Get NodePort if exists
    $nodePort = kubectl get svc -n $NAMESPACE -o jsonpath='{.items[?(@.spec.type=="NodePort")].spec.ports[0].nodePort}' 2>$null

    if ($nodePort) {
        $nodeIp = kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'
        Write-Host "Service accessible at:" -ForegroundColor Green
        Write-Host "  NodePort: http://${nodeIp}:${nodePort}" -ForegroundColor Cyan
    } else {
        Write-Host "No NodePort service found" -ForegroundColor Yellow
        Write-Host "Use port-forward: kubectl port-forward -n $NAMESPACE svc/$APP_NAME-internal 8080:8080" -ForegroundColor Cyan
    }

    Write-Host ""
    Print-Warning "Useful commands:"
    Write-Host "  Logs: kubectl logs -f -l app=$APP_NAME -n $NAMESPACE"
    Write-Host "  Scale: kubectl scale deployment $APP_NAME --replicas=3 -n $NAMESPACE"
    Write-Host "  Delete: kubectl delete namespace $NAMESPACE"
}

# ============================================
# Main execution
# ============================================

if ($Help) {
    Write-Host "Usage: .\deploy.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -SkipBuild    Skip Docker image build"
    Write-Host "  -SkipLoad     Skip loading images to cluster"
    Write-Host "  -Help         Show this help message"
    exit 0
}

Print-Header "Kubernetes Deployment Script"
Write-Host "App Name: $APP_NAME"
Write-Host "Namespace: $NAMESPACE"
Write-Host "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
Write-Host ""

# Execute deployment steps
Check-Prerequisites

if (-not $SkipBuild) {
    Build-Images
} else {
    Print-Warning "Skipping image build (-SkipBuild)"
}

if (-not $SkipLoad) {
    Load-Images
} else {
    Print-Warning "Skipping image load (-SkipLoad)"
}

Deploy-Manifests
Wait-ForDeployment
Show-Status
Show-AccessInfo

Print-Header "Deployment Complete!"
