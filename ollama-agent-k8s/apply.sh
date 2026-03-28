#!/bin/bash
set -e

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   🚀 Deploying Ollama Agent (Local K8s)     ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Step 1: Namespace and Storage
echo "Step 1/7 → Creating namespace and storage..."
kubectl apply -f cluster/namespace.yaml
kubectl apply -f cluster/storageclass.yaml
echo "✅ Done"
sleep 2

# Step 2: Secret — MUST be before MongoDB and Backend
echo ""
echo "Step 2/7 → Applying Secret..."
kubectl apply -f backend/secret.yaml
echo "✅ Secret created"
sleep 1

# Step 3: MongoDB
echo ""
echo "Step 3/7 → Deploying MongoDB..."
kubectl apply -f mongodb/configmap.yaml
kubectl apply -f mongodb/persistentvolumeclaim.yaml
kubectl apply -f mongodb/service.yaml
kubectl apply -f mongodb/statefulset.yaml

echo "Waiting for MongoDB (may take ~60 seconds)..."
kubectl rollout status statefulset/ollama-mongodb -n ollama-agent --timeout=180s
echo "✅ MongoDB ready"
sleep 5

# Step 4: Ollama — MUST be before Backend
echo ""
echo "Step 4/7 → Deploying Ollama (tinyllama download ~600MB)..."
kubectl apply -f ollama/pvc.yaml
kubectl apply -f ollama/configmap.yaml
kubectl apply -f ollama/service.yaml
kubectl apply -f ollama/nodeport.yaml
kubectl apply -f ollama/deployment.yaml

echo "Waiting for Ollama init (tinyllama downloading — may take 3-10 min)..."
kubectl rollout status deployment/ollama -n ollama-agent --timeout=600s
echo "✅ Ollama ready"
sleep 5

# Step 5: Backend
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

# Step 6: Frontend
echo ""
echo "Step 6/7 → Deploying Frontend..."
kubectl apply -f frontend/configmap.yaml
kubectl apply -f frontend/deployment.yaml
kubectl apply -f frontend/service.yaml
kubectl apply -f frontend/hpa.yaml

echo "Waiting for Frontend..."
kubectl rollout status deployment/ollama-frontend -n ollama-agent --timeout=120s
echo "✅ Frontend ready"

# Step 7: Ingress
echo ""
echo "Step 7/7 → Applying Ingress..."
kubectl apply -f cluster/ingress.yaml
echo "✅ Done"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   ✅ Deployment complete!                   ║"
echo "║   Open: http://localhost                    ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
kubectl get pods -n ollama-agent
echo ""
kubectl get services -n ollama-agent
