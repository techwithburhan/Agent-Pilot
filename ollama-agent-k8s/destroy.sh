#!/bin/bash

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   🗑️  Destroying Ollama Agent Deployment    ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

kubectl delete -f cluster/ingress.yaml --ignore-not-found
kubectl delete -f frontend/hpa.yaml --ignore-not-found
kubectl delete -f frontend/service.yaml --ignore-not-found
kubectl delete -f frontend/deployment.yaml --ignore-not-found
kubectl delete -f frontend/configmap.yaml --ignore-not-found
kubectl delete -f backend/hpa.yaml --ignore-not-found
kubectl delete -f backend/service.yaml --ignore-not-found
kubectl delete -f backend/deployment.yaml --ignore-not-found
kubectl delete -f backend/configmap.yaml --ignore-not-found
kubectl delete -f backend/secret.yaml --ignore-not-found
kubectl delete -f ollama/deployment.yaml --ignore-not-found
kubectl delete -f ollama/nodeport.yaml --ignore-not-found
kubectl delete -f ollama/service.yaml --ignore-not-found
kubectl delete -f ollama/configmap.yaml --ignore-not-found
kubectl delete -f ollama/pvc.yaml --ignore-not-found
kubectl delete -f mongodb/statefulset.yaml --ignore-not-found
kubectl delete -f mongodb/service.yaml --ignore-not-found
kubectl delete -f mongodb/persistentvolumeclaim.yaml --ignore-not-found
kubectl delete -f mongodb/configmap.yaml --ignore-not-found
kubectl delete -f cluster/storageclass.yaml --ignore-not-found
kubectl delete -f cluster/namespace.yaml --ignore-not-found

echo ""
echo "✅ All resources deleted."
echo ""
