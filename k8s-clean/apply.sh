#!/bin/bash
set -e

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║   🚀 Deploying Ollama Agent (kind)            ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# ── Step 0: Install NGINX Ingress Controller ──────────
echo "Step 0/7 → Installing NGINX Ingress..."

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

echo "Waiting for Ingress Controller..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo "🔍 Verifying Ingress pods..."
kubectl get pods -n ingress-nginx
echo "✅ Ingress ready"
sleep 3

# ── Step 1: Namespace & StorageClass ─────────────────
echo ""
echo "Step 1/7 → Creating namespace and storage..."
kubectl apply -f cluster/namespace.yaml
kubectl apply -f cluster/storageclass.yaml
echo "✅ Done"
sleep 2

# ── Step 2: Secret ───────────────────────────────────
echo ""
echo "Step 2/7 → Applying Secret..."
kubectl apply -f backend/secret.yaml
echo "✅ Secret created"
sleep 1

# ── Step 3: Ollama ───────────────────────────────────
echo ""
echo "Step 3/7 → Deploying Ollama..."
kubectl apply -f ollama/pvc.yaml
kubectl apply -f ollama/configmap.yaml
kubectl apply -f ollama/deployment.yaml
kubectl apply -f ollama/service.yaml
kubectl apply -f ollama/nodeport.yaml

echo "Waiting for Ollama..."
kubectl rollout status deployment/ollama -n ollama-agent --timeout=300s
echo "✅ Ollama ready"
sleep 3

# ── Step 4: MongoDB ───────────────────────────────────
echo ""
echo "Step 4/7 → Deploying MongoDB..."
kubectl apply -f mongodb/persistentvolumeclaim.yaml
kubectl apply -f mongodb/service.yaml
kubectl apply -f mongodb/statefulset.yaml

echo "Waiting for MongoDB..."
kubectl rollout status statefulset/ollama-mongodb -n ollama-agent --timeout=180s
echo "✅ MongoDB ready"
sleep 5

# ── Step 5: Backend ───────────────────────────────────
echo ""
echo "Step 5/7 → Deploying Backend..."
kubectl apply -f backend/configmap.yaml
kubectl apply -f backend/deployment.yaml
kubectl apply -f backend/service.yaml
kubectl apply -f backend/hpa.yaml

echo "Waiting for Backend..."
kubectl rollout status deployment/ollama-backend -n ollama-agent --timeout=120s
echo "✅ Backend ready"
sleep 3

# ── Step 6: Frontend ──────────────────────────────────
echo ""
echo "Step 6/7 → Deploying Frontend..."
kubectl apply -f frontend/configmap.yaml
kubectl apply -f frontend/deployment.yaml
kubectl apply -f frontend/service.yaml
kubectl apply -f frontend/hpa.yaml

echo "Waiting for Frontend..."
kubectl rollout status deployment/ollama-frontend -n ollama-agent --timeout=120s
echo "✅ Frontend ready"

# ── Step 7: Ingress Resource ─────────────────────────
echo ""
echo "Step 7/7 → Applying Ingress..."
kubectl apply -f cluster/ingress.yaml
echo "✅ Done"

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║   ✅ Deployment complete! 🚀                  ║"
echo "║                                               ║"
echo "║   Run port-forward to access locally          ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

kubectl get pods -n ollama-agent
echo ""
kubectl get services -n ollama-agent