# Ollama Agent — kind Setup

## Folder Structure

```
k8s/
├── kind-cluster.yaml          ← kind cluster config (run first)
├── apply.sh                   ← deploy everything
├── port-forward.sh            ← expose all services locally
├── destroy.sh                 ← tear down
│
├── cluster/
│   ├── namespace.yaml         ← ollama-agent namespace
│   ├── storageclass.yaml      ← local-path (kind built-in)
│   └── ingress.yaml           ← HTTP routing + SSE
│
├── mongodb/
│   ├── persistentvolumeclaim.yaml  ← 10Gi local storage
│   ├── service.yaml           ← headless service
│   └── statefulset.yaml       ← MongoDB pod + health checks
│
├── backend/
│   ├── secret.yaml            ← JWT + MongoDB URI (base64)
│   ├── configmap.yaml         ← port, Ollama URL, model
│   ├── deployment.yaml        ← 2 replicas + initContainers
│   ├── service.yaml           ← ClusterIP
│   └── hpa.yaml               ← 2-10 pods auto-scale
│
├── frontend/
│   ├── configmap.yaml         ← nginx config + API URL
│   ├── deployment.yaml        ← 2 replicas + initContainer
│   ├── service.yaml           ← ClusterIP
│   └── hpa.yaml               ← 2-8 pods auto-scale
│
└── ollama/
    ├── pvc.yaml               ← 30Gi local storage (models persist)
    ├── configmap.yaml         ← Ollama settings
    ├── deployment.yaml        ← tinyllama auto-pull on first boot
    ├── service.yaml           ← ClusterIP (internal access)
    └── nodeport.yaml          ← NodePort 31434 (direct debug access)
```

---

## Before You Start

### 1. Replace image names
Edit these two files and set your actual Docker images:
- `backend/deployment.yaml`  → `image: your-registry/ollama-backend:latest`
- `frontend/deployment.yaml` → `image: your-registry/ollama-frontend:latest`

### 2. Change secrets (optional)
Default values in `backend/secret.yaml`:
- `MONGO_USERNAME` = admin
- `MONGO_PASSWORD` = password123
- `JWT_SECRET`     = my-super-secret-jwt-key

To change:
```bash
echo -n 'yournewvalue' | base64
```
Paste the output into `backend/secret.yaml`.

---

## Step-by-Step: First Time Setup

### Step 1 — Create the kind cluster
```bash
kind create cluster --name ollama-agent --config kind-cluster.yaml
```

### Step 2 — Install nginx ingress controller for kind
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for ingress controller to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

### Step 3 — Deploy everything
```bash
chmod +x apply.sh port-forward.sh destroy.sh
./apply.sh
```

### Step 4 — Start port-forwards
```bash
./port-forward.sh
```

---

## Port-Forward Commands (individually)

Run each in a separate terminal if you want them one at a time:

```bash
# Frontend — http://localhost:8080
kubectl port-forward svc/ollama-frontend 8080:80 -n ollama-agent

# Backend — http://localhost:3000
kubectl port-forward svc/ollama-backend 3000:3000 -n ollama-agent

# Ollama — http://localhost:11434
kubectl port-forward svc/ollama-service 11434:11434 -n ollama-agent

# MongoDB — localhost:27017
kubectl port-forward svc/ollama-mongodb 27017:27017 -n ollama-agent
```

Or all at once (background):
```bash
./port-forward.sh        # start all
./port-forward.sh stop   # stop all
```

---

## Access URLs

| Service   | URL                          |
|-----------|------------------------------|
| Frontend  | http://localhost:8080        |
| Backend   | http://localhost:3000        |
| Ollama    | http://localhost:11434       |
| Ollama (NodePort) | http://localhost:31434 |
| MongoDB   | localhost:27017              |

---

## Useful Debug Commands

```bash
# Check all pods
kubectl get pods -n ollama-agent

# Check all services
kubectl get services -n ollama-agent

# Watch pods in real time
kubectl get pods -n ollama-agent -w

# Logs for a service
kubectl logs -f deployment/ollama -n ollama-agent
kubectl logs -f deployment/ollama-backend -n ollama-agent
kubectl logs -f deployment/ollama-frontend -n ollama-agent
kubectl logs -f statefulset/ollama-mongodb -n ollama-agent

# Describe a pod (good for crash debugging)
kubectl describe pod <pod-name> -n ollama-agent

# Shell into a pod
kubectl exec -it deployment/ollama -n ollama-agent -- /bin/bash
kubectl exec -it statefulset/ollama-mongodb -n ollama-agent -- mongosh

# Test Ollama directly
curl http://localhost:11434/api/version
curl http://localhost:11434/api/tags

# Test tinyllama
curl http://localhost:11434/api/generate -d '{
  "model": "tinyllama",
  "prompt": "Hello!",
  "stream": false
}'
```

---

## Tear Down

```bash
./destroy.sh          # removes namespace + resources, keeps kind cluster
./destroy.sh --all    # also deletes the kind cluster completely
```

---

## Storage Info

kind uses `rancher.io/local-path` provisioner (built-in, no setup needed).  
Data is stored inside the kind container at `/var/local-path-provisioner/`.  
It persists across pod restarts but is lost if the kind cluster is deleted.
