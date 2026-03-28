#!/bin/bash
# Starts port-forwards for all services in background.
# Each one opens in a separate process so they all run together.
# Run:  ./port-forward.sh
# Stop: ./port-forward.sh stop

NS="ollama-agent"

stop_all() {
  echo ""
  echo "Stopping all port-forwards..."
  pkill -f "kubectl port-forward" 2>/dev/null || true
  echo "✅ All port-forwards stopped"
  exit 0
}

if [ "$1" == "stop" ]; then
  stop_all
fi

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║   🔌 Starting Port Forwards (kind)            ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# Kill any existing port-forwards first
pkill -f "kubectl port-forward" 2>/dev/null || true
sleep 1

# ── Frontend → http://localhost:8080 ─────────────────
kubectl port-forward svc/ollama-frontend 8080:80 -n $NS &
PF1=$!
echo "✅ Frontend   →  http://localhost:8080"

# ── Backend → http://localhost:3000 ──────────────────
kubectl port-forward svc/ollama-backend 3000:3000 -n $NS &
PF2=$!
echo "✅ Backend    →  http://localhost:3000"

# ── Ollama → http://localhost:11434 ──────────────────
kubectl port-forward svc/ollama-service 11434:11434 -n $NS &
PF3=$!
echo "✅ Ollama     →  http://localhost:11434"

# ── MongoDB → localhost:27017 ─────────────────────────
kubectl port-forward svc/ollama-mongodb 27017:27017 -n $NS &
PF4=$!
echo "✅ MongoDB    →  localhost:27017"

echo ""
echo "  All services forwarded. Press Ctrl+C to stop all."
echo "  Or run:  ./port-forward.sh stop"
echo ""

# Wait and clean up on Ctrl+C
trap stop_all INT TERM
wait $PF1 $PF2 $PF3 $PF4
