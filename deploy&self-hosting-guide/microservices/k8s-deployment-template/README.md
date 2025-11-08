# Kubernetes On-Premise Deployment Template

**Doc-Type:** Template Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

Project-agnostic K8s deployment templates → on-premise clusters → minimal drift → maximum reusability

---

## Overview

**Components:**
- Generic manifests (namespace/deployment/service/configmap) w/ variable placeholders
- Cross-platform scripts (bash + PowerShell)
- Image distribution (kind/minikube/registry/manual)
- Multi-service examples
- Production patterns (probes/scaling/monitoring)

**Structure:**
```
k8s-deployment-template/
├── manifests/          # K8s YAML with ${VARIABLE} placeholders
├── scripts/            # deploy.sh, deploy.ps1, load-images-to-nodes.sh
└── examples/           # multi-service reference
```

---

## Quick Deploy

```bash
# 1. Set variables
export APP_NAME="my-app" NAMESPACE="my-app" IMAGE_NAME="my-app" IMAGE_TAG="latest"

# 2. Deploy (Linux/Mac)
cd scripts && chmod +x deploy.sh && ./deploy.sh

# 3. Verify
kubectl get all -n ${NAMESPACE}
```

---

## Configuration Variables

**Manifest Placeholders:**
```
Core:           ${NAMESPACE}, ${APP_NAME}, ${VERSION}
Image:          ${IMAGE_NAME}, ${IMAGE_TAG}, ${IMAGE_PULL_POLICY}, ${CONTAINER_PORT}
Service:        ${SERVICE_PORT}, ${NODE_PORT}
Resources:      ${MEMORY_REQUEST/LIMIT}, ${CPU_REQUEST/LIMIT}
Health:         ${LIVENESS/READINESS_PATH}, ${LIVENESS/READINESS_INITIAL_DELAY}
Deployment:     ${REPLICAS}, ${CONTAINER_NAME}
```

**Script Env Vars:**
```bash
APP_NAME, NAMESPACE, IMAGE_NAME, IMAGE_TAG, BUILD_CONTEXT, MANIFESTS_DIR, REGISTRY_URL
```

---

## Deployment Methods

**Automated (dev/test):**
```bash
./scripts/deploy.sh                    # Full: build + load + deploy
./scripts/deploy.sh --skip-build       # Use existing image
./scripts/deploy.sh --skip-load        # Registry-based
```

**Manual (production):**
```bash
# Build
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ${BUILD_CONTEXT}

# Load (choose one)
kind load docker-image ${IMAGE_NAME}:${IMAGE_TAG}                   # kind
minikube image load ${IMAGE_NAME}:${IMAGE_TAG}                      # minikube
./scripts/load-images-to-nodes.sh registry ${IMAGE_NAME}:${IMAGE_TAG}  # registry
./scripts/load-images-to-nodes.sh manual ${IMAGE_NAME}:${IMAGE_TAG}    # tar files

# Deploy
kubectl apply -k manifests/  # kustomize
# OR
kubectl apply -f manifests/namespace.yaml -f manifests/configmap.yaml \
  -f manifests/deployment.yaml -f manifests/service.yaml

# Wait
kubectl wait --for=condition=ready pod -l app=${APP_NAME} -n ${NAMESPACE} --timeout=300s
```

**Kustomize Overlays (multi-env):**
```bash
overlays/{dev,staging,production}/kustomization.yaml
kubectl apply -k overlays/production/
```

---

## Image Distribution

| Method | Use Case | Command |
|--------|----------|---------|
| Private Registry | Production, multi-node | `docker tag/push → ${REGISTRY_URL}/image:tag` |
| kind/minikube | Local dev | `kind load docker-image` / `minikube image load` |
| Manual | Air-gapped, small clusters | `./load-images-to-nodes.sh manual` → scp + load |

---

## Service Exposure

| Type | Access | Use Case | Pros | Cons |
|------|--------|----------|------|------|
| **NodePort** (default) | `http://<node-ip>:<30000-32767>` | Simple on-prem | No extra components | Limited ports, manual LB |
| **LoadBalancer** | External IP | Cloud/MetalLB | Auto LB | Requires cloud/MetalLB |
| **Ingress** | HTTP(S) domain routing | Production multi-service | Path routing, TLS | Needs Ingress controller |
| **Port-Forward** | `localhost:8080` | Dev/debug only | Quick access | Temporary |

**Ingress Example:**
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
            port: {number: 8080}
```

---

## Resource Management

**Requests vs Limits:**
- **Requests:** Guaranteed → scheduling
- **Limits:** Max → prevent overconsumption

```yaml
resources:
  requests: {memory: "512Mi", cpu: "500m"}   # Guaranteed
  limits: {memory: "2Gi", cpu: "2000m"}      # Max (OOMKill/throttle)
```

**Sizing:**
- Small (API): 256Mi/250m → 1Gi/1000m
- Medium (Web): 512Mi/500m → 2Gi/2000m
- Large (DB): 1Gi/1000m → 4Gi/4000m

**HPA (auto-scaling):**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef: {kind: Deployment, name: ${APP_NAME}}
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - {type: Resource, resource: {name: cpu, target: {type: Utilization, averageUtilization: 70}}}
  - {type: Resource, resource: {name: memory, target: {type: Utilization, averageUtilization: 80}}}
```

---

## Health Checks

| Probe | Purpose | Action | Config |
|-------|---------|--------|--------|
| **Liveness** | Detect unhealthy → restart | `path: /health, initialDelay: 60s, period: 30s` | Check critical deps, return 200/5xx |
| **Readiness** | Detect ready → route traffic | `path: /ready, initialDelay: 30s, period: 10s` | Faster checks, return 200/503 |
| **Startup** | Slow startup → prevent early kill | `failureThreshold: 30 (300s total)` | For slow-starting apps |

```yaml
livenessProbe: {httpGet: {path: /health, port: 8080}, initialDelaySeconds: 60, periodSeconds: 30}
readinessProbe: {httpGet: {path: /ready, port: 8080}, initialDelaySeconds: 30, periodSeconds: 10}
```

---

## Configuration

**ConfigMap (non-sensitive):**
```yaml
data:
  APP_ENV: "production"
  LOG_LEVEL: "info"
```
```yaml
env:
- name: APP_ENV
  valueFrom: {configMapKeyRef: {name: ${APP_NAME}-config, key: APP_ENV}}
```

**Secrets (sensitive):**
```bash
kubectl create secret generic ${APP_NAME}-secrets \
  --from-literal=db-password=pass --from-literal=api-key=key -n ${NAMESPACE}
```
```yaml
env:
- name: DB_PASSWORD
  valueFrom: {secretKeyRef: {name: ${APP_NAME}-secrets, key: db-password}}
```

**Best Practices:**
- Never commit secrets → use Vault/SealedSecrets
- Rotate regularly, limit RBAC access

---

## Monitoring

**Logging:**
```bash
kubectl logs -f -l app=${APP_NAME} -n ${NAMESPACE}          # All pods
kubectl logs --previous ${POD_NAME} -n ${NAMESPACE}          # After crash
```
Production: ELK, Loki+Grafana, Fluentd

**Metrics:**
```bash
kubectl top pods/nodes -n ${NAMESPACE}
```
Prometheus: Add annotations `prometheus.io/{scrape,port,path}`

**Events:**
```bash
kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp'
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
```

---

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| **ImagePullBackOff** | Can't pull image | `kind load docker-image` OR `kubectl edit deployment` → `imagePullPolicy: Never` |
| **CrashLoopBackOff** | Container crashing | `kubectl logs --previous` + check health paths + increase `initialDelaySeconds` |
| **Pending** | Insufficient resources | `kubectl describe pod` → reduce requests OR add nodes |
| **Service inaccessible** | Network/config | Check `kubectl get svc/endpoints` → `kubectl port-forward` (temp) |

**Quick diagnostics:**
```bash
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}             # Events + config
kubectl logs ${POD_NAME} -n ${NAMESPACE}                     # App logs
kubectl exec ${POD_NAME} -n ${NAMESPACE} -- curl localhost:8080/health  # Test endpoint
```

---

## Production Readiness

**Security:** Non-root containers · Drop capabilities · NetworkPolicies · External secrets (Vault) · RBAC least-privilege · Image scanning · Private registry

**Reliability:** Resource limits · Liveness/readiness probes · Replicas ≥2 · PodDisruptionBudgets · HPA · Anti-affinity · Graceful shutdown

**Observability:** Centralized logging · Prometheus metrics · Distributed tracing · Health endpoints · Alerting · Dashboards · SLI/SLO

**Operations:** Deployment strategy (RollingUpdate) · Rollback procedure · Backup/restore · CI/CD · IaC versioned · DR plan · Runbooks

---

## Advanced Patterns

**Blue-Green:**
```bash
kubectl apply -f deployment-v2.yaml
kubectl wait --for=condition=ready pod -l version=v2
kubectl patch svc ${SERVICE_NAME} -p '{"spec":{"selector":{"version":"v2"}}}'
kubectl delete deployment ${APP_NAME}-v1
```

**Canary (gradual):**
```bash
kubectl scale deployment ${APP_NAME}-canary --replicas=1    # 10%
kubectl scale deployment ${APP_NAME}-stable --replicas=9
# Monitor → gradually increase canary
```

**StatefulSet:**
```yaml
kind: StatefulSet
spec:
  serviceName: ${APP_NAME}
  volumeClaimTemplates:
  - metadata: {name: data}
    spec: {accessModes: ["ReadWriteOnce"], resources: {requests: {storage: 10Gi}}}
```

---

## Cleanup

```bash
kubectl delete namespace ${NAMESPACE}                        # All resources
kubectl delete -k manifests/                                 # Kustomize
docker rmi ${IMAGE_NAME}:${IMAGE_TAG}                       # Local image
```

---

## Customization

```bash
# 1. Copy template
cp -r k8s-deployment-template your-project/k8s

# 2. Create config.env with all variables
# 3. Replace placeholders
source config.env && envsubst < manifests/deployment.yaml | kubectl apply -f -
# OR use kustomize patches

# 4. Commit
git add k8s/ && git commit -m "Add K8s deployment"
```

---

## Quick Reference

**Essential kubectl:**
```bash
# Status
kubectl get all -n ${NAMESPACE}
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
kubectl logs -f ${POD_NAME} -n ${NAMESPACE}

# Rollout
kubectl rollout status/history/undo deployment/${APP_NAME} -n ${NAMESPACE}

# Scale
kubectl scale deployment ${APP_NAME} --replicas=5 -n ${NAMESPACE}

# Debug
kubectl exec -it ${POD_NAME} -n ${NAMESPACE} -- /bin/bash
kubectl port-forward svc/${SERVICE_NAME} 8080:8080 -n ${NAMESPACE}
kubectl debug -it ${POD_NAME} --image=busybox -n ${NAMESPACE}
```

---

## Resources

**Internal:** [Main README](../../README.md) · [Automation](../automation.md) · [QUICKSTART](QUICKSTART.md)

**External:** [K8s Docs](https://kubernetes.io/docs/) · [kubectl Ref](https://kubernetes.io/docs/reference/kubectl/) · [kind](https://kind.sigs.k8s.io/) · [k9s](https://k9scli.io/) · [kustomize](https://kustomize.io/)

---

**Version:** 1.0.0 · **K8s:** 1.20+ · **Updated:** 2025-11-08 · **Maintained:** AI Whisperers
