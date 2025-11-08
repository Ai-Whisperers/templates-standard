# Kubernetes On-Premise Deployment Template

**Doc-Type:** Template Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

This template provides standardized Kubernetes deployment configurations and scripts for on-premise clusters. Designed for Docker-based containerized applications with production-ready patterns.

---

## Overview

**Purpose:** Project-agnostic K8s deployment templates → on-premise clusters → minimal configuration drift → maximum reusability

**Core Components:**
- Generic manifests (namespace, deployment, service, configmap)
- Cross-platform deployment scripts (bash + PowerShell)
- Image loading utilities (kind/minikube/registry/manual)
- Multi-service deployment examples
- Production-ready patterns (health checks, resource limits, auto-scaling ready)

---

## Template Structure

```
k8s-deployment-template/
├── README.md                    # This file
├── QUICKSTART.md                # Fast-path deployment guide
│
├── manifests/                   # Kubernetes manifests
│   ├── namespace.yaml           # Namespace definition
│   ├── configmap.yaml           # Configuration management
│   ├── deployment.yaml          # Application deployment
│   ├── service.yaml             # Service exposure (ClusterIP + NodePort)
│   └── kustomization.yaml       # Kustomize overlay
│
├── scripts/                     # Deployment automation
│   ├── deploy.sh                # Linux/Mac deployment script
│   ├── deploy.ps1               # Windows PowerShell script
│   └── load-images-to-nodes.sh  # Image distribution helper
│
└── examples/                    # Reference implementations
    └── multi-service/           # Multi-tier deployment example
```

---

## Quick Start

### Prerequisites

**Required:**
- Kubernetes cluster (v1.20+) → accessible via kubectl
- Docker → image building
- kubectl → cluster management

**Verification:**
```bash
kubectl version --client
docker --version
kubectl cluster-info
```

### Deploy in 3 Steps

**1. Customize Variables**

Edit deployment script or set environment variables:

```bash
export APP_NAME="my-app"
export NAMESPACE="my-app"
export IMAGE_NAME="my-app"
export IMAGE_TAG="latest"
export BUILD_CONTEXT="."
```

**2. Run Deployment Script**

Linux/Mac:
```bash
cd scripts
chmod +x deploy.sh
./deploy.sh
```

Windows:
```powershell
cd scripts
.\deploy.ps1
```

**3. Verify Deployment**

```bash
kubectl get all -n ${NAMESPACE}
kubectl logs -f -l app=${APP_NAME} -n ${NAMESPACE}
```

---

## Configuration Variables

### Manifest Placeholders

Replace these in manifests before deployment:

**Core Variables:**
- `${NAMESPACE}` → Kubernetes namespace (e.g., "my-app")
- `${APP_NAME}` → Application identifier (e.g., "my-app")
- `${VERSION}` → Application version (e.g., "v1.0.0")

**Image Configuration:**
- `${IMAGE_NAME}` → Docker image name (e.g., "my-app")
- `${IMAGE_TAG}` → Image tag (e.g., "latest", "v1.0.0")
- `${IMAGE_PULL_POLICY}` → Pull policy ("IfNotPresent", "Always", "Never")
- `${CONTAINER_NAME}` → Container name in pod spec
- `${CONTAINER_PORT}` → Container listening port (e.g., 8080)

**Service Configuration:**
- `${SERVICE_PORT}` → Service port (e.g., 8080)
- `${NODE_PORT}` → NodePort for external access (30000-32767)

**Resource Limits:**
- `${MEMORY_REQUEST}` → Memory request (e.g., "512Mi")
- `${MEMORY_LIMIT}` → Memory limit (e.g., "2Gi")
- `${CPU_REQUEST}` → CPU request (e.g., "500m")
- `${CPU_LIMIT}` → CPU limit (e.g., "2000m")

**Health Checks:**
- `${LIVENESS_PATH}` → Liveness probe HTTP path (e.g., "/health")
- `${READINESS_PATH}` → Readiness probe HTTP path (e.g., "/ready")
- `${LIVENESS_INITIAL_DELAY}` → Seconds before first liveness probe (e.g., 60)
- `${READINESS_INITIAL_DELAY}` → Seconds before first readiness probe (e.g., 30)

**Deployment Configuration:**
- `${REPLICAS}` → Number of pod replicas (e.g., 2)

### Script Environment Variables

Scripts support these environment variables:

```bash
APP_NAME="my-app"              # Application name
NAMESPACE="my-app"             # Kubernetes namespace
IMAGE_NAME="my-app"            # Docker image name
IMAGE_TAG="latest"             # Docker image tag
BUILD_CONTEXT="."              # Docker build context path
MANIFESTS_DIR="./manifests"    # Path to manifest files
REGISTRY_URL=""                # Private registry URL (optional)
```

---

## Deployment Methods

### Method 1: Automated Script Deployment

**Best for:** Quick deployments, development environments

```bash
# Full deployment (build + load + deploy)
./scripts/deploy.sh

# Skip build (image already exists)
./scripts/deploy.sh --skip-build

# Skip image loading (using registry)
./scripts/deploy.sh --skip-load
```

### Method 2: Manual Deployment

**Best for:** Production, custom workflows

**Step 1:** Build image
```bash
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ${BUILD_CONTEXT}
```

**Step 2:** Load to cluster (choose one)

```bash
# For kind
kind load docker-image ${IMAGE_NAME}:${IMAGE_TAG}

# For minikube
minikube image load ${IMAGE_NAME}:${IMAGE_TAG}

# For private registry
./scripts/load-images-to-nodes.sh registry ${IMAGE_NAME}:${IMAGE_TAG}

# For manual distribution
./scripts/load-images-to-nodes.sh manual ${IMAGE_NAME}:${IMAGE_TAG}
```

**Step 3:** Deploy manifests

```bash
# Using kustomize
kubectl apply -k manifests/

# Or apply individually
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/configmap.yaml
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
```

**Step 4:** Wait for ready state

```bash
kubectl wait --for=condition=ready pod -l app=${APP_NAME} -n ${NAMESPACE} --timeout=300s
```

### Method 3: Kustomize Overlays

**Best for:** Multiple environments (dev/staging/prod)

Create environment-specific overlays:

```bash
overlays/
├── dev/
│   └── kustomization.yaml      # Dev-specific config
├── staging/
│   └── kustomization.yaml      # Staging config
└── production/
    └── kustomization.yaml      # Production config
```

Deploy to specific environment:

```bash
kubectl apply -k overlays/production/
```

---

## Image Distribution Strategies

### Strategy 1: Private Registry

**Best for:** Production, multi-node clusters

```bash
# Set registry URL
export REGISTRY_URL="registry.example.com"

# Tag and push
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}
docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}

# Update manifests to use registry image
# Set imagePullPolicy: Always
```

### Strategy 2: Local Development (kind/minikube)

**Best for:** Local development, single-node testing

```bash
# kind
kind load docker-image ${IMAGE_NAME}:${IMAGE_TAG}

# minikube
minikube image load ${IMAGE_NAME}:${IMAGE_TAG}

# Set imagePullPolicy: Never or IfNotPresent
```

### Strategy 3: Manual Distribution

**Best for:** Air-gapped environments, small clusters

```bash
# Save images
./scripts/load-images-to-nodes.sh manual ${IMAGE_NAME}:${IMAGE_TAG}

# Copy and load on each node
scp ${IMAGE_NAME//[\/:]/\-}.tar.gz node1:/tmp/
ssh node1 "docker load < /tmp/${IMAGE_NAME//[\/:]/\-}.tar.gz"
```

---

## Service Exposure Options

### Option 1: NodePort (Default)

Exposes service on each node's IP at static port (30000-32767).

**Access:** `http://<node-ip>:<node-port>`

**Configuration:**
```yaml
spec:
  type: NodePort
  ports:
  - port: 8080
    nodePort: 30800
```

**Pros:**
- Simple, no additional components
- Direct access from outside cluster

**Cons:**
- Limited port range
- Manual load balancing needed

### Option 2: LoadBalancer

Provisions external load balancer (cloud environments).

**Configuration:**
```yaml
spec:
  type: LoadBalancer
  ports:
  - port: 8080
    targetPort: 8080
```

**Pros:**
- Automatic load balancing
- Cloud-native integration

**Cons:**
- Requires cloud provider or MetalLB
- Potential cost implications

### Option 3: Ingress

HTTP/HTTPS routing with path-based routing and TLS termination.

**Configuration:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${APP_NAME}-ingress
spec:
  rules:
  - host: ${DOMAIN}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ${APP_NAME}-internal
            port:
              number: 8080
```

**Pros:**
- Path-based routing
- TLS/SSL termination
- Single entry point for multiple services

**Cons:**
- Requires Ingress controller (nginx, traefik, etc.)
- Additional configuration complexity

### Option 4: Port-Forward (Development Only)

Temporary access for testing.

```bash
kubectl port-forward -n ${NAMESPACE} svc/${APP_NAME}-internal 8080:8080
```

**Access:** `http://localhost:8080`

---

## Resource Management

### Resource Requests vs Limits

**Requests:** Guaranteed resources → scheduling decisions
**Limits:** Maximum resources → prevent overconsumption

```yaml
resources:
  requests:
    memory: "512Mi"    # Guaranteed 512MB
    cpu: "500m"        # Guaranteed 0.5 CPU cores
  limits:
    memory: "2Gi"      # Max 2GB before OOMKilled
    cpu: "2000m"       # Max 2 CPU cores (throttled if exceeded)
```

### Sizing Guidelines

**Small Service (API, microservice):**
- Memory: 256Mi request, 1Gi limit
- CPU: 250m request, 1000m limit

**Medium Service (Web app, processing):**
- Memory: 512Mi request, 2Gi limit
- CPU: 500m request, 2000m limit

**Large Service (Database, heavy processing):**
- Memory: 1Gi request, 4Gi limit
- CPU: 1000m request, 4000m limit

### Horizontal Pod Autoscaling (HPA)

Enable automatic scaling based on CPU/memory:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ${APP_NAME}-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ${APP_NAME}
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

---

## Health Checks

### Liveness Probe

**Purpose:** Detect when container is unhealthy → restart container

**Configuration:**
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 60    # Wait before first check
  periodSeconds: 30          # Check every 30s
  timeoutSeconds: 10         # 10s timeout
  failureThreshold: 3        # Restart after 3 failures
```

**Best Practices:**
- Check critical dependencies (DB, cache)
- Longer initialDelaySeconds for slow-starting apps
- Return 200 if healthy, 5xx if unhealthy

### Readiness Probe

**Purpose:** Detect when container is ready to serve traffic → remove from service endpoints

**Configuration:**
```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 30    # Wait before first check
  periodSeconds: 10          # Check every 10s
  timeoutSeconds: 5          # 5s timeout
  failureThreshold: 3        # Remove after 3 failures
```

**Best Practices:**
- Faster checks than liveness
- Return 200 when ready, 503 when warming up
- Check external dependencies availability

### Startup Probe

**Purpose:** Handle slow-starting containers → prevent premature liveness failures

```yaml
startupProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 0
  periodSeconds: 10
  failureThreshold: 30       # Allow 300s (30 × 10s) for startup
```

---

## Configuration Management

### ConfigMap Usage

**Environment-specific values:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${APP_NAME}-config
data:
  APP_ENV: "production"
  LOG_LEVEL: "info"
  CACHE_TTL: "3600"
  MAX_CONNECTIONS: "100"
```

**Consumption methods:**

**1. Environment variables:**
```yaml
env:
- name: APP_ENV
  valueFrom:
    configMapKeyRef:
      name: ${APP_NAME}-config
      key: APP_ENV
```

**2. Volume mount (file-based config):**
```yaml
volumes:
- name: config
  configMap:
    name: ${APP_NAME}-config
containers:
- volumeMounts:
  - name: config
    mountPath: /etc/config
```

### Secrets Management

**Sensitive data:** Passwords, API keys, certificates

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secrets
type: Opaque
data:
  database-password: <base64-encoded-value>
  api-key: <base64-encoded-value>
```

**Create from literal:**
```bash
kubectl create secret generic ${APP_NAME}-secrets \
  --from-literal=database-password=secretpass \
  --from-literal=api-key=abc123 \
  -n ${NAMESPACE}
```

**Consume in pod:**
```yaml
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: ${APP_NAME}-secrets
      key: database-password
```

**Best Practices:**
- Never commit secrets to Git
- Use external secret managers (Vault, Sealed Secrets) for production
- Rotate secrets regularly
- Limit RBAC access to secrets

---

## Monitoring & Observability

### Logging

**View logs:**
```bash
# All pods in deployment
kubectl logs -f -l app=${APP_NAME} -n ${NAMESPACE}

# Specific pod
kubectl logs -f ${POD_NAME} -n ${NAMESPACE}

# Previous container (after crash)
kubectl logs --previous ${POD_NAME} -n ${NAMESPACE}

# Multi-container pod (specific container)
kubectl logs -f ${POD_NAME} -c ${CONTAINER_NAME} -n ${NAMESPACE}
```

**Centralized logging (production):**
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Loki + Grafana
- Fluentd/Fluent Bit → cloud logging

### Metrics

**Built-in metrics:**
```bash
# Resource usage
kubectl top pods -n ${NAMESPACE}
kubectl top nodes

# Deployment status
kubectl get deployment ${APP_NAME} -n ${NAMESPACE}
```

**Prometheus integration:**

Add annotations to deployment:
```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/metrics"
```

### Events

**View cluster events:**
```bash
# Namespace events
kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp'

# Pod-specific events
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
```

---

## Troubleshooting

### Common Issues

**Issue: ImagePullBackOff**

**Cause:** Kubernetes cannot pull Docker image

**Solutions:**
```bash
# 1. Check image exists locally
docker images | grep ${IMAGE_NAME}

# 2. Load to cluster (if local)
kind load docker-image ${IMAGE_NAME}:${IMAGE_TAG}

# 3. Change pull policy
kubectl edit deployment ${APP_NAME} -n ${NAMESPACE}
# Set: imagePullPolicy: Never or IfNotPresent

# 4. Check registry credentials (if private)
kubectl get secrets -n ${NAMESPACE}
kubectl create secret docker-registry regcred \
  --docker-server=${REGISTRY_URL} \
  --docker-username=${USERNAME} \
  --docker-password=${PASSWORD}
```

**Issue: CrashLoopBackOff**

**Cause:** Container repeatedly crashing

**Solutions:**
```bash
# 1. Check logs
kubectl logs ${POD_NAME} -n ${NAMESPACE}
kubectl logs --previous ${POD_NAME} -n ${NAMESPACE}

# 2. Check events
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}

# 3. Verify health check endpoints
kubectl exec ${POD_NAME} -n ${NAMESPACE} -- curl localhost:8080/health

# 4. Check resource limits
kubectl describe pod ${POD_NAME} -n ${NAMESPACE} | grep -A 5 "Limits"

# 5. Increase probe delays
# Edit deployment: increase initialDelaySeconds
```

**Issue: Pending Pods**

**Cause:** Insufficient resources or scheduling constraints

**Solutions:**
```bash
# 1. Check pod events
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}

# 2. Check node resources
kubectl top nodes
kubectl describe nodes

# 3. Reduce resource requests
# Edit deployment: lower requests.memory/cpu

# 4. Add more nodes or remove resource constraints
```

**Issue: Service Not Accessible**

**Cause:** Network configuration or service misconfiguration

**Solutions:**
```bash
# 1. Verify service exists
kubectl get svc -n ${NAMESPACE}

# 2. Check service endpoints
kubectl get endpoints ${SERVICE_NAME} -n ${NAMESPACE}

# 3. Test from within cluster
kubectl run test-pod --image=curlimages/curl -it --rm -- \
  curl http://${SERVICE_NAME}.${NAMESPACE}:8080

# 4. Check NodePort accessibility
kubectl get svc ${SERVICE_NAME} -n ${NAMESPACE} -o wide

# 5. Verify firewall rules
# Ensure NodePort range (30000-32767) is open

# 6. Use port-forward as workaround
kubectl port-forward -n ${NAMESPACE} svc/${SERVICE_NAME} 8080:8080
```

---

## Production Readiness Checklist

### Security

- [ ] Use non-root containers (securityContext.runAsNonRoot: true)
- [ ] Drop unnecessary capabilities
- [ ] Enable read-only root filesystem where possible
- [ ] Implement Pod Security Standards/Admission
- [ ] Use NetworkPolicies to restrict traffic
- [ ] Store secrets in external secret manager (Vault, etc.)
- [ ] Enable RBAC with least privilege
- [ ] Scan images for vulnerabilities
- [ ] Use private registry with authentication
- [ ] Enable audit logging

### Reliability

- [ ] Define resource requests and limits
- [ ] Implement liveness and readiness probes
- [ ] Set appropriate replica count (≥ 2)
- [ ] Configure Pod Disruption Budgets
- [ ] Implement HPA for auto-scaling
- [ ] Use anti-affinity for multi-zone distribution
- [ ] Configure graceful shutdown (preStop hooks)
- [ ] Set pod priority classes

### Observability

- [ ] Centralized logging configured
- [ ] Metrics exposed (Prometheus format)
- [ ] Distributed tracing enabled
- [ ] Health check endpoints implemented
- [ ] Alerting rules configured
- [ ] Dashboard created (Grafana, etc.)
- [ ] SLI/SLO defined

### Operations

- [ ] Deployment strategy defined (RollingUpdate/Recreate)
- [ ] Rollback procedure documented
- [ ] Backup/restore procedures tested
- [ ] CI/CD pipeline configured
- [ ] Infrastructure as Code (IaC) version controlled
- [ ] Disaster recovery plan documented
- [ ] Runbooks created for common issues

---

## Advanced Patterns

### Blue-Green Deployment

Deploy new version alongside old → switch traffic atomically

```bash
# Deploy v2 (green)
kubectl apply -f deployment-v2.yaml

# Wait for ready
kubectl wait --for=condition=ready pod -l app=${APP_NAME},version=v2

# Switch service selector to v2
kubectl patch svc ${SERVICE_NAME} -p '{"spec":{"selector":{"version":"v2"}}}'

# Remove v1 (blue) after validation
kubectl delete deployment ${APP_NAME}-v1
```

### Canary Deployment

Gradually shift traffic to new version

```bash
# Deploy canary (10% traffic)
kubectl apply -f deployment-canary.yaml
kubectl scale deployment ${APP_NAME}-canary --replicas=1
kubectl scale deployment ${APP_NAME}-stable --replicas=9

# Increase canary traffic gradually
# Monitor metrics → increase replicas if healthy

# Full rollout
kubectl scale deployment ${APP_NAME}-canary --replicas=10
kubectl scale deployment ${APP_NAME}-stable --replicas=0
```

### StatefulSet (Stateful Applications)

For applications requiring stable network identity and persistent storage

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ${APP_NAME}
spec:
  serviceName: ${APP_NAME}
  replicas: 3
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    # ... pod template ...
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

---

## Cleanup

### Delete Deployment

**Remove all resources:**
```bash
kubectl delete namespace ${NAMESPACE}
```

**Remove individual resources:**
```bash
kubectl delete deployment ${APP_NAME} -n ${NAMESPACE}
kubectl delete service ${APP_NAME}-internal -n ${NAMESPACE}
kubectl delete service ${APP_NAME}-external -n ${NAMESPACE}
kubectl delete configmap ${APP_NAME}-config -n ${NAMESPACE}
```

**Using kustomize:**
```bash
kubectl delete -k manifests/
```

### Cleanup Local Images

```bash
docker rmi ${IMAGE_NAME}:${IMAGE_TAG}
```

---

## Customization Guide

### Adapting for Your Project

**1. Copy template to your project:**
```bash
cp -r k8s-deployment-template your-project/k8s
```

**2. Replace placeholders:**

Create `config.env`:
```bash
export APP_NAME="your-app"
export NAMESPACE="your-namespace"
export IMAGE_NAME="your-image"
export IMAGE_TAG="v1.0.0"
export CONTAINER_PORT="8080"
export NODE_PORT="30800"
export REPLICAS="2"
# ... add all variables
```

**3. Apply replacements:**

Using `envsubst`:
```bash
source config.env
envsubst < manifests/deployment.yaml | kubectl apply -f -
```

Or use kustomize with patches.

**4. Commit customized version:**
```bash
git add k8s/
git commit -m "Add Kubernetes deployment configuration"
```

---

## Reference

### Useful kubectl Commands

```bash
# Cluster info
kubectl cluster-info
kubectl get nodes -o wide

# Namespace management
kubectl create namespace ${NAMESPACE}
kubectl get namespaces

# Deployment management
kubectl apply -f manifest.yaml
kubectl get deployments -n ${NAMESPACE}
kubectl describe deployment ${APP_NAME} -n ${NAMESPACE}
kubectl rollout status deployment/${APP_NAME} -n ${NAMESPACE}
kubectl rollout history deployment/${APP_NAME} -n ${NAMESPACE}
kubectl rollout undo deployment/${APP_NAME} -n ${NAMESPACE}

# Pod management
kubectl get pods -n ${NAMESPACE}
kubectl get pods -n ${NAMESPACE} -o wide
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
kubectl logs -f ${POD_NAME} -n ${NAMESPACE}
kubectl exec -it ${POD_NAME} -n ${NAMESPACE} -- /bin/bash
kubectl delete pod ${POD_NAME} -n ${NAMESPACE}

# Service management
kubectl get svc -n ${NAMESPACE}
kubectl describe svc ${SERVICE_NAME} -n ${NAMESPACE}
kubectl get endpoints -n ${NAMESPACE}

# ConfigMap and Secrets
kubectl get configmap -n ${NAMESPACE}
kubectl describe configmap ${CONFIG_NAME} -n ${NAMESPACE}
kubectl get secrets -n ${NAMESPACE}

# Scaling
kubectl scale deployment ${APP_NAME} --replicas=5 -n ${NAMESPACE}
kubectl autoscale deployment ${APP_NAME} --min=2 --max=10 --cpu-percent=70 -n ${NAMESPACE}

# Resource usage
kubectl top nodes
kubectl top pods -n ${NAMESPACE}

# Port forwarding
kubectl port-forward -n ${NAMESPACE} pod/${POD_NAME} 8080:8080
kubectl port-forward -n ${NAMESPACE} svc/${SERVICE_NAME} 8080:8080

# Debug
kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp'
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
kubectl debug -it ${POD_NAME} -n ${NAMESPACE} --image=busybox
```

---

## Support & Resources

**Internal Documentation:**
- [Main README](../../README.md) - AI Whisperers standards overview
- [Automation System](../automation.md) - CI/CD integration
- [QUICKSTART.md](QUICKSTART.md) - Fast deployment guide

**Kubernetes Documentation:**
- [Official K8s Docs](https://kubernetes.io/docs/)
- [kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Service Types](https://kubernetes.io/docs/concepts/services-networking/service/)

**Tools:**
- [kind](https://kind.sigs.k8s.io/) - Local Kubernetes clusters
- [minikube](https://minikube.sigs.k8s.io/) - Local Kubernetes
- [k9s](https://k9scli.io/) - Terminal UI for K8s
- [Lens](https://k8slens.dev/) - Kubernetes IDE
- [kustomize](https://kustomize.io/) - Configuration management

---

**Template Version:** 1.0.0
**Compatible K8s Versions:** 1.20+
**Last Updated:** 2025-11-08
**Maintained by:** AI Whisperers
