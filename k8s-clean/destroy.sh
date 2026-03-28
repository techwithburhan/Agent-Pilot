#!/bin/bash
# Tears down everything from the cluster.
# Pass --all to also delete the kind cluster itself.

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║   🗑️  Destroying Ollama Agent                 ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# Stop any running port-forwards
pkill -f "kubectl port-forward" 2>/dev/null || true

kubectl delete namespace ollama-agent --ignore-not-found
kubectl delete storageclass local-path --ignore-not-found

echo "✅ All Kubernetes resources removed"

if [ "$1" == "--all" ]; then
  echo "Deleting kind cluster..."
  kind delete cluster --name ollama-agent 2>/dev/null || kind delete cluster
  echo "✅ kind cluster deleted"
fi

echo ""
