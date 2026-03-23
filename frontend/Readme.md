# Frontend folder mein jao
cd ollama-agent/frontend

# Local build
docker build -t ollama-agent-frontend .

# Run karo
docker run -d -p 3000:80 ollama-agent-frontend

# Browser mein kholo
# http://localhost:3000
```

---

## 🎯 Tumhare .env Variables ka Kya Hua
```
DANGEROUSLY_DISABLE_HOST_CHECK  ← Sirf npm start mein kaam karta tha ✅ ignore
WDS_SOCKET_HOST                 ← Webpack dev server ke liye tha     ✅ ignore  
WDS_SOCKET_PORT                 ← Webpack dev server ke liye tha     ✅ ignore
HOST                            ← Local binding ke liye tha          ✅ ignore
