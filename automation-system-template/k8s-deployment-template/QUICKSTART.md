# Kubernetes Deployment - Quick Start

**Doc-Type:** Quick Start Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

Get your application running on Kubernetes in under 5 minutes. This guide covers the fastest path from Docker image to deployed service.

---

## Prerequisites Check

```bash
# Verify tools installed
kubectl version --client
docker --version
kubectl cluster-info
```

**Required:**
- Kubernetes cluster (accessible)
- Docker (installed)
- kubectl (configured)

---

## Option 1: Automated Deployment (Recommended)

**Time: ~3 minutes**

### Step 1: Configure Environment

```bash
# Set your application details
export APP_NAME="my-app"
export NAMESPACE="my-app"
export IMAGE_NAME="my-app"
export IMAGE_TAG="latest"
export BUILD_CONTEXT="."
```

### Step 2: Run Deployment Script

**Linux/Mac:**
```bash
cd scripts
chmod +x deploy.sh
./deploy.sh
```

**Windows:**
```powershell
cd scripts
.\deploy.ps1
```

### Step 3: Access Your Service

```bash
# Get node IP and NodePort
kubectl get nodes -o wide
kubectl get svc -n ${NAMESPACE}

# Access: http://<node-ip>:<node-port>
```

**Done!** Your service is deployed.

---

## Option 2: Manual Deployment

**Time: ~5 minutes**

### Step 1: Build Image

```bash
docker build -t my-app:latest .
```

### Step 2: Load to Cluster

**For kind:**
```bash
kind load docker-image my-app:latest
```

**For minikube:**
```bash
minikube image load my-app:latest
```

**For other clusters:**
```bash
./scripts/load-images-to-nodes.sh manual my-app:latest
# Follow printed instructions
```

### Step 3: Customize Manifests

Replace placeholders in `manifests/*.yaml`:

**Quick replacement (Linux/Mac):**
```bash
cd manifests

# Create temporary files with replacements
export APP_NAME="my-app"
export NAMESPACE="my-app"
export IMAGE_NAME="my-app"
export IMAGE_TAG="latest"
export CONTAINER_NAME="my-app"
export CONTAINER_PORT="8080"
export SERVICE_PORT="8080"
export NODE_PORT="30800"
export REPLICAS="2"
export VERSION="v1.0.0"
export IMAGE_PULL_POLICY="IfNotPresent"
export MEMORY_REQUEST="512Mi"
export MEMORY_LIMIT="2Gi"
export CPU_REQUEST="500m"
export CPU_LIMIT="2000m"
export LIVENESS_PATH="/health"
export READINESS_PATH="/health"
export LIVENESS_INITIAL_DELAY="60"
export READINESS_INITIAL_DELAY="30"

# Apply with envsubst
for file in *.yaml; do
    envsubst < "$file" | kubectl apply -f -
done
```

**Manual replacement:**

Edit each file in `manifests/` directory:
- Replace `${APP_NAME}` with your app name
- Replace `${NAMESPACE}` with your namespace
- Replace `${IMAGE_NAME}` and `${IMAGE_TAG}` with your image details
- Replace other placeholders as needed

### Step 4: Deploy

```bash
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/configmap.yaml
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
```

**Or use kustomize:**
```bash
kubectl apply -k manifests/
```

### Step 5: Verify

```bash
# Wait for ready state
kubectl wait --for=condition=ready pod -l app=my-app -n my-app --timeout=300s

# Check status
kubectl get all -n my-app
```

---

## Verification Steps

### Check Pod Status

```bash
kubectl get pods -n ${NAMESPACE}
# Should show: Running, 2/2 ready
```

### Check Service

```bash
kubectl get svc -n ${NAMESPACE}
# Note the NodePort (30000-32767)
```

### Test Health Endpoint

```bash
# Get node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Get NodePort
NODE_PORT=$(kubectl get svc -n ${NAMESPACE} -o jsonpath='{.items[?(@.spec.type=="NodePort")].spec.ports[0].nodePort}')

# Test endpoint
curl http://$NODE_IP:$NODE_PORT/health
```

### View Logs

```bash
kubectl logs -f -l app=${APP_NAME} -n ${NAMESPACE}
```

---

## Common Quick Fixes

### Problem: ImagePullBackOff

**Solution:**
```bash
# Load image to cluster
kind load docker-image ${IMAGE_NAME}:${IMAGE_TAG}

# Or change pull policy
kubectl edit deployment ${APP_NAME} -n ${NAMESPACE}
# Change: imagePullPolicy: Never
```

### Problem: CrashLoopBackOff

**Solution:**
```bash
# Check logs
kubectl logs -l app=${APP_NAME} -n ${NAMESPACE}

# Check health endpoint path in deployment.yaml
# Ensure it matches your application
```

### Problem: Can't Access Service

**Solution:**
```bash
# Use port-forward temporarily
kubectl port-forward -n ${NAMESPACE} svc/${APP_NAME}-internal 8080:8080

# Access at: http://localhost:8080
```

---

## Next Steps

**Scale your deployment:**
```bash
kubectl scale deployment ${APP_NAME} --replicas=5 -n ${NAMESPACE}
```

**Update configuration:**
```bash
kubectl edit configmap ${APP_NAME}-config -n ${NAMESPACE}
kubectl rollout restart deployment/${APP_NAME} -n ${NAMESPACE}
```

**Monitor resources:**
```bash
kubectl top pods -n ${NAMESPACE}
kubectl top nodes
```

**View events:**
```bash
kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp'
```

---

## Cleanup

**Remove everything:**
```bash
kubectl delete namespace ${NAMESPACE}
```

**Remove specific deployment:**
```bash
kubectl delete deployment ${APP_NAME} -n ${NAMESPACE}
kubectl delete service ${APP_NAME}-internal ${APP_NAME}-external -n ${NAMESPACE}
```

---

## Need More Details?

- **Full guide:** See [README.md](README.md)
- **Multi-service setup:** See [examples/multi-service/](examples/multi-service/)
- **Troubleshooting:** See README.md → Troubleshooting section
- **Production setup:** See README.md → Production Readiness Checklist

---

**Quick Start Version:** 1.0.0
**Last Updated:** 2025-11-08
