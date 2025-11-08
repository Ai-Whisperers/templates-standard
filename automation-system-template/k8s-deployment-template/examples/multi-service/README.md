# Multi-Service Deployment Example

**Doc-Type:** Example Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

Multi-tier application pattern: frontend (public) → backend (internal) → interdependent services

---

## Architecture

**Two-Service Pattern:**
```
External → Frontend (NodePort:30800) → Backend (ClusterIP:8080)
         Port: 8000                    Internal processing
```

**Use Cases:**
- Web frontend + REST API backend
- API gateway + microservices
- Multi-language stacks (Python+Java, Node+Go)
- Processing pipelines

---

## Structure

```
multi-service/
├── namespace.yaml               # Shared namespace
├── configmap.yaml               # Shared config
├── backend-deployment.yaml      # Backend (ClusterIP, port 8080)
├── frontend-deployment.yaml     # Frontend (NodePort 30800/30815)
└── kustomization.yaml           # Deployment orchestration
```

**Service Definitions:**

| Service | Exposure | Ports | Health | Purpose |
|---------|----------|-------|--------|---------|
| **Backend** | ClusterIP (internal) | 8080 | `/api/health` | Processing, business logic |
| **Frontend** | NodePort (external) | 8000 (HTTP), 8815 (gRPC) | `/health` | Public API, calls backend |

---

## Deployment

**Kustomize (recommended):**
```bash
kubectl apply -k .
kubectl wait --for=condition=ready pod -l tier=backend -n multi-service --timeout=300s
kubectl wait --for=condition=ready pod -l tier=frontend -n multi-service --timeout=300s
```

**Manual (sequential - backend first):**
```bash
kubectl apply -f namespace.yaml -f configmap.yaml -f backend-deployment.yaml
kubectl wait --for=condition=ready pod -l app=backend -n multi-service --timeout=300s
kubectl apply -f frontend-deployment.yaml
kubectl get all -n multi-service
```

**Automated Script:**
```bash
export NAMESPACE="multi-service" BACKEND_IMAGE="my-backend:latest" FRONTEND_IMAGE="my-frontend:latest"
../../scripts/deploy.sh
```

---

## Service Communication

**Internal DNS:** `<service>.<namespace>.svc.cluster.local`

**Frontend → Backend:**
```yaml
env:
- name: BACKEND_URL
  value: "http://backend-service:8080"  # Short form (same namespace)
```

**Load Balancing:** Automatic round-robin across backend pods

**Session Affinity (optional):**
```yaml
spec:
  sessionAffinity: ClientIP
  sessionAffinityConfig: {clientIP: {timeoutSeconds: 10800}}
```

---

## Scaling

**Independent:**
```bash
kubectl scale deployment backend --replicas=5 -n multi-service    # CPU-intensive
kubectl scale deployment frontend --replicas=3 -n multi-service   # Request-heavy
```

**HPA (auto-scaling):**
```yaml
# Frontend: CPU-driven (70%), Backend: Memory-driven (80%)
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef: {kind: Deployment, name: frontend}
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - {type: Resource, resource: {name: cpu, target: {type: Utilization, averageUtilization: 70}}}
```

---

## Monitoring

```bash
kubectl get all -n multi-service                              # Overview
kubectl get pods -l tier=backend/frontend -n multi-service    # By tier
kubectl logs -f -l app=backend -n multi-service               # Backend logs
kubectl logs -f -l app=frontend -n multi-service              # Frontend logs
stern -n multi-service '.*'                                   # All logs (requires stern)

# Test inter-service communication
FRONTEND_POD=$(kubectl get pod -n multi-service -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $FRONTEND_POD -n multi-service -- curl http://backend-service:8080/api/health
```

---

## Troubleshooting

| Issue | Check | Fix |
|-------|-------|-----|
| **Frontend can't reach backend** | `kubectl exec $FRONTEND_POD -- nslookup backend-service`<br>`kubectl get endpoints backend-service` | Verify backend pods ready<br>Check NetworkPolicies |
| **Backend not starting** | `kubectl get events --sort-by='.lastTimestamp'`<br>`kubectl logs -l app=backend` | Check ConfigMap exists<br>Review startup order |
| **Timeouts** | `kubectl top pods` | Increase `initialDelaySeconds`<br>Check resource throttling |

---

## Production Patterns

**Deployment Strategies:**

| Pattern | Method | Use Case |
|---------|--------|----------|
| **Rolling** | `kubectl set image deployment/backend backend=v2.0` | Zero-downtime updates |
| **Blue-Green** | Deploy v2 → switch service selector → delete v1 | Instant rollback |
| **Canary** | `scale canary --replicas=1` (10%) → monitor → increase | Gradual validation |

**Service Mesh (advanced):**
- Istio/Linkerd: mTLS, traffic routing, tracing, circuit breaking
- Simple alternative: NetworkPolicies + health checks + Prometheus

**Resilience:**
```python
# Circuit breaking
@circuit(failure_threshold=5, recovery_timeout=60)
def call_backend(endpoint):
    return requests.get(f"{backend_url}{endpoint}", timeout=5)

# Retry logic
@retry(stop=stop_after_attempt(3), wait=wait_exponential(min=2, max=10))
def call_backend_with_retry(endpoint):
    return requests.get(f"{backend_url}{endpoint}", timeout=5)
```

---

## Application Code Examples

**Backend (Flask):**
```python
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/api/health')
def health():
    return jsonify({"status": "healthy", "service": "backend"}), 200

@app.route('/api/data')
def get_data():
    return jsonify({"data": [1, 2, 3], "processed": True}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))
```

**Frontend (FastAPI):**
```python
from fastapi import FastAPI
import httpx, os

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
```

---

## Extending to 3+ Services

**Pattern:** Frontend → API Gateway → Backend → Cache (Redis) → Database (PostgreSQL)

**Principles:**
- Deploy dependencies first: DB → Cache → Backend → Gateway → Frontend
- Use init containers for dependency waiting
- StatefulSets for databases
- PersistentVolumeClaims for data
- Health checks at each layer

**Next additions:**
- Monitoring: Prometheus + Grafana
- Tracing: Jaeger, Zipkin
- Logging: ELK, Loki
- Security: NetworkPolicies, PSS
- Service mesh: Istio, Linkerd
- Ingress: nginx-ingress, Traefik

---

## Cleanup

```bash
kubectl delete namespace multi-service    # All resources
kubectl delete -k .                        # Kustomize
```

---

**Version:** 1.0.0 · **Pattern:** Two-tier microservices · **Updated:** 2025-11-08
