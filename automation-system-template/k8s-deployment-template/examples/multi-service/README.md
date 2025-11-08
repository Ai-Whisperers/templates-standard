# Multi-Service Deployment Example

**Doc-Type:** Example Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

This example demonstrates deploying a multi-tier application with interdependent services. Common pattern: API gateway + backend service, web frontend + API backend, or layered microservices.

---

## Architecture Example

**Two-Service Pattern:**

```
┌─────────────────┐
│   External      │
│   Traffic       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Frontend       │  (Service A - Public-facing)
│  Port: 8000     │  → Exposed via NodePort
│  NodePort:30800 │  → Communicates with Backend
└────────┬────────┘
         │ Internal
         │ ClusterIP
         ▼
┌─────────────────┐
│  Backend        │  (Service B - Internal)
│  Port: 8080     │  → ClusterIP only
│                 │  → Processes business logic
└─────────────────┘
```

**Use Cases:**
- Web frontend (React/Vue) + REST API backend
- API gateway + microservices
- Processing pipeline with multiple stages
- Multi-language stack (Python + Java, Node + Go, etc.)

---

## File Structure

```
multi-service/
├── README.md                    # This file
├── namespace.yaml               # Shared namespace
├── configmap.yaml               # Shared configuration
├── backend-deployment.yaml      # Backend service (internal)
├── frontend-deployment.yaml     # Frontend service (public)
└── kustomization.yaml           # Kustomize overlay
```

---

## Configuration

### Service Definitions

**Backend Service (Service A):**
- Internal processing, business logic
- ClusterIP service (internal only)
- Port: 8080
- Health check: `/api/health`
- No external exposure

**Frontend Service (Service B):**
- Public-facing API or web server
- Calls backend via internal DNS
- Ports: 8000 (HTTP), 8815 (optional gRPC)
- NodePort: 30800, 30815
- Health check: `/health`

### Environment Variables

**Shared (in ConfigMap):**
```yaml
APP_ENV: "production"
LOG_LEVEL: "info"
```

**Frontend-specific:**
```yaml
BACKEND_URL: "http://backend-service:8080"  # Internal DNS
```

**Backend-specific:**
```yaml
MAX_WORKERS: "4"
CACHE_SIZE: "1000"
```

---

## Deployment Instructions

### Method 1: Using Kustomize

```bash
# From multi-service directory
kubectl apply -k .

# Wait for both services
kubectl wait --for=condition=ready pod -l tier=backend -n multi-service --timeout=300s
kubectl wait --for=condition=ready pod -l tier=frontend -n multi-service --timeout=300s
```

### Method 2: Manual Sequential Deployment

**Important:** Deploy backend first, then frontend (dependency order).

```bash
# 1. Create namespace
kubectl apply -f namespace.yaml

# 2. Apply shared config
kubectl apply -f configmap.yaml

# 3. Deploy backend first (dependency)
kubectl apply -f backend-deployment.yaml

# 4. Wait for backend ready
kubectl wait --for=condition=ready pod -l app=backend -n multi-service --timeout=300s

# 5. Deploy frontend (depends on backend)
kubectl apply -f frontend-deployment.yaml

# 6. Wait for frontend ready
kubectl wait --for=condition=ready pod -l app=frontend -n multi-service --timeout=300s

# 7. Verify all running
kubectl get all -n multi-service
```

### Method 3: Automated Script

```bash
# Set environment variables
export NAMESPACE="multi-service"
export BACKEND_IMAGE="my-backend:latest"
export FRONTEND_IMAGE="my-frontend:latest"

# Run deployment (from scripts directory)
cd ../../scripts
./deploy.sh
```

---

## Service Communication

### Internal DNS Resolution

Services communicate via Kubernetes DNS:

**Format:** `<service-name>.<namespace>.svc.cluster.local`

**Examples:**
```bash
# Short form (same namespace)
http://backend-service:8080

# Full DNS name
http://backend-service.multi-service.svc.cluster.local:8080
```

### Connection Configuration

**Frontend environment variable:**
```yaml
env:
- name: BACKEND_URL
  value: "http://backend-service:8080"
```

**Frontend code (example):**
```python
import os
import requests

backend_url = os.getenv("BACKEND_URL", "http://backend-service:8080")
response = requests.get(f"{backend_url}/api/data")
```

---

## Scaling Strategies

### Independent Scaling

Scale services independently based on load:

```bash
# Scale backend (CPU-intensive processing)
kubectl scale deployment backend --replicas=5 -n multi-service

# Scale frontend (handle more requests)
kubectl scale deployment frontend --replicas=3 -n multi-service
```

### Coordinated Scaling

Scale both services proportionally:

```bash
# Example: 2:1 ratio (frontend:backend)
kubectl scale deployment frontend --replicas=4 -n multi-service
kubectl scale deployment backend --replicas=2 -n multi-service
```

### Auto-scaling

```yaml
# Frontend HPA (HTTP traffic driven)
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: frontend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: frontend
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70

---
# Backend HPA (processing load driven)
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: backend
  minReplicas: 2
  maxReplicas: 8
  metrics:
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

---

## Load Balancing

### Backend Load Balancing

**Automatic:** Kubernetes Service provides round-robin load balancing

When frontend calls `http://backend-service:8080`:
- Traffic distributed across all backend pods
- No configuration needed
- Session affinity optional

**Session Affinity (optional):**
```yaml
spec:
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 10800  # 3 hours
```

### Frontend Load Balancing

**NodePort:** Manual external load balancer needed

**LoadBalancer:** Cloud provider handles automatically

**Ingress:** Path-based routing with single entry point

---

## Monitoring Multi-Service Deployments

### Check All Services

```bash
# Overview
kubectl get all -n multi-service

# Pods by tier
kubectl get pods -l tier=backend -n multi-service
kubectl get pods -l tier=frontend -n multi-service

# Services
kubectl get svc -n multi-service
```

### View Logs

```bash
# Backend logs
kubectl logs -f -l app=backend -n multi-service

# Frontend logs
kubectl logs -f -l app=frontend -n multi-service

# Both services (requires stern or similar)
stern -n multi-service '.*'
```

### Test Inter-Service Communication

```bash
# Get a frontend pod name
FRONTEND_POD=$(kubectl get pod -n multi-service -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# Test backend connectivity from frontend pod
kubectl exec -it $FRONTEND_POD -n multi-service -- curl http://backend-service:8080/api/health
```

---

## Troubleshooting Multi-Service Issues

### Frontend Can't Reach Backend

**Check DNS resolution:**
```bash
# From frontend pod
kubectl exec -it $FRONTEND_POD -n multi-service -- nslookup backend-service
```

**Check backend service endpoints:**
```bash
kubectl get endpoints backend-service -n multi-service
# Should list backend pod IPs
```

**Check network policies:**
```bash
kubectl get networkpolicies -n multi-service
# Ensure no policies blocking traffic
```

**Verify backend is ready:**
```bash
kubectl get pods -l app=backend -n multi-service
# All pods should show READY 1/1 or 2/2
```

### Backend Pods Not Starting

**Check startup order:**
```bash
# Backend should start first
kubectl get events -n multi-service --sort-by='.lastTimestamp'
```

**Check dependencies:**
```bash
# Ensure required ConfigMaps exist
kubectl get configmap -n multi-service

# Check backend logs
kubectl logs -l app=backend -n multi-service
```

### Service Communication Timeouts

**Increase readiness probe delays:**

Edit `backend-deployment.yaml`:
```yaml
readinessProbe:
  initialDelaySeconds: 60  # Increase if backend slow to start
```

**Check resource limits:**
```bash
# Backend might be CPU throttled
kubectl top pods -n multi-service
```

---

## Production Considerations

### Service Mesh (Advanced)

For complex multi-service architectures, consider service mesh:

**Istio, Linkerd Benefits:**
- Automatic mTLS encryption
- Advanced traffic routing (canary, A/B)
- Distributed tracing
- Circuit breaking
- Retry policies

**Simple setup without mesh:**
- Use NetworkPolicies for security
- Implement health checks properly
- Use readiness probes to prevent traffic to unhealthy pods
- Monitor with Prometheus/Grafana

### Circuit Breaking

Prevent cascading failures:

**Frontend code example:**
```python
from circuitbreaker import circuit

@circuit(failure_threshold=5, recovery_timeout=60)
def call_backend(endpoint):
    response = requests.get(f"{backend_url}{endpoint}", timeout=5)
    response.raise_for_status()
    return response.json()
```

### Retry Logic

Handle transient failures:

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=2, max=10))
def call_backend_with_retry(endpoint):
    return requests.get(f"{backend_url}{endpoint}", timeout=5)
```

---

## Deployment Patterns

### Rolling Update (Default)

Update one service at a time without downtime:

```bash
# Update backend image
kubectl set image deployment/backend backend=my-backend:v2.0 -n multi-service

# Watch rollout
kubectl rollout status deployment/backend -n multi-service

# Update frontend after backend ready
kubectl set image deployment/frontend frontend=my-frontend:v2.0 -n multi-service
kubectl rollout status deployment/frontend -n multi-service
```

### Blue-Green Deployment

**Backend blue-green:**
```bash
# Deploy green version
kubectl apply -f backend-deployment-green.yaml

# Switch service selector
kubectl patch svc backend-service -n multi-service -p '{"spec":{"selector":{"version":"green"}}}'

# Remove blue after validation
kubectl delete deployment backend-blue -n multi-service
```

### Canary Deployment

**Gradual rollout:**
```bash
# Deploy canary (10% traffic)
kubectl apply -f backend-deployment-canary.yaml
kubectl scale deployment backend-canary --replicas=1 -n multi-service
kubectl scale deployment backend-stable --replicas=9 -n multi-service

# Monitor metrics, increase canary if healthy
kubectl scale deployment backend-canary --replicas=5 -n multi-service
kubectl scale deployment backend-stable --replicas=5 -n multi-service
```

---

## Example Application Code

### Backend Service (Python Flask)

```python
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/api/health')
def health():
    return jsonify({"status": "healthy", "service": "backend"}), 200

@app.route('/api/data')
def get_data():
    return jsonify({"data": [1, 2, 3], "processed": True}), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
```

### Frontend Service (Python FastAPI)

```python
from fastapi import FastAPI
import httpx
import os

app = FastAPI()
backend_url = os.getenv("BACKEND_URL", "http://backend-service:8080")

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "frontend"}

@app.get("/data")
async def get_data():
    async with httpx.AsyncClient() as client:
        response = await client.get(f"{backend_url}/api/data", timeout=5.0)
        return response.json()

if __name__ == '__main__':
    import uvicorn
    port = int(os.getenv('PORT', 8000))
    uvicorn.run(app, host='0.0.0.0', port=port)
```

---

## Cleanup

```bash
# Delete all resources
kubectl delete namespace multi-service

# Or delete individually
kubectl delete -k .
```

---

## Extending to More Services

### Three-Service Pattern

```
Frontend (Web UI) → API Gateway → Backend Services
                    ↓
                  Cache (Redis)
                    ↓
                  Database (PostgreSQL)
```

**Key principles:**
- Deploy dependencies first (DB → Cache → Backend → Gateway → Frontend)
- Use init containers to wait for dependencies
- Implement health checks at each layer
- Use StatefulSets for databases
- Use PersistentVolumeClaims for data persistence

---

## Next Steps

- **Add monitoring:** Prometheus, Grafana
- **Add tracing:** Jaeger, Zipkin
- **Add logging:** ELK stack, Loki
- **Add security:** NetworkPolicies, Pod Security Standards
- **Add service mesh:** Istio, Linkerd
- **Add ingress:** nginx-ingress, Traefik

---

**Example Version:** 1.0.0
**Pattern:** Two-tier microservices
**Last Updated:** 2025-11-08
