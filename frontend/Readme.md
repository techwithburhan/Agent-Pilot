## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine using Docker.

### Prerequisites

  * [Docker](https://docs.docker.com/get-docker/) installed and running on your system.

### 🐳 Installation & Run Commands

**1. Navigate to the Frontend Directory**

```bash
cd ollama-agent/frontend
```

**2. Build the Docker Image**

```bash
docker build -t ollama-agent-frontend .
```

**3. Run the Docker Container**

```bash
docker run -d -p 3000:80 ollama-agent-frontend
```

**4. Access the Application**
Open your browser and visit:
👉 **[http://localhost:3000](https://www.google.com/search?q=http://localhost:3000)**

> **Note:** The container serves the production build using Nginx on internal port 80. If port `3000` is already in use on your host machine, you can map it to a different port:
>
> ```bash
> docker run -d -p 3001:80 ollama-agent-frontend
> ```

-----

## ⚙️ Environment Variables

The following environment variables were primarily used during local development (`npm start`) and are **not required** for the Docker production build. They can be safely ignored in the Docker setup:

| Variable | Usage | Status in Docker |
| :--- | :--- | :--- |
| `DANGEROUSLY_DISABLE_HOST_CHECK` | Disables host checking (dev only) | ❌ Ignored |
| `WDS_SOCKET_HOST` | Webpack dev server config | ❌ Ignored |
| `WDS_SOCKET_PORT` | Webpack dev server config | ❌ Ignored |
| `HOST` | Local binding configuration | ❌ Ignored |

-----

## 📦 Tech Stack

  * **Frontend Framework:** React.js
  * **Containerization:** Docker
  * **Web Server:** Nginx

-----

## 🌐 Advanced Deployment (Future Scope)

As the project scales, this containerized frontend is fully ready to be integrated into broader architectures:

  * **Kubernetes:** Deployable via standard `Deployment` and `Service` manifests.
  * **AWS:** Ready for deployment on Amazon ECS, EKS, or EC2 instances behind an Application Load Balancer.
  * **CI/CD:** Easily integratable into Jenkins or GitHub Actions pipelines for automated builds.

-----

## 📌 Author

**Burhan**
🚀 *Tech with Burhan* \`\`\`

Ekdum set hai\! 🚀 Would you like me to also draft a quick `docker-compose.yml` file or a Kubernetes `deployment.yaml` file so you can take this frontend setup to the next level?
