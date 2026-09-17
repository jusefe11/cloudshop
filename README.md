# ☁️ CloudShop — DevOps & GitOps Project

![Docker](https://img.shields.io/badge/Docker-Containers-blue?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-blue?logo=kubernetes)
![Helm](https://img.shields.io/badge/Helm-Package_Manager-blue?logo=helm)
![ArgoCD](https://img.shields.io/badge/Argo_CD-GitOps-orange?logo=argo)
![GitHub](https://img.shields.io/badge/GitHub-Repository-black?logo=github)
![Nginx](https://img.shields.io/badge/Nginx-Frontend-green?logo=nginx)
![Python](https://img.shields.io/badge/Python-Flask-yellow?logo=python)

CloudShop es un laboratorio DevOps basado en una arquitectura de microservicios, diseñado para implementar y demostrar un flujo completo de contenerización, orquestación con Kubernetes, despliegues con Helm y GitOps mediante Argo CD.

El proyecto permite administrar toda la infraestructura de la aplicación de forma declarativa desde Git.

---

## 🏗️ Arquitectura

```text
                    ┌──────────────────────┐
                    │       Usuario        │
                    └──────────┬───────────┘
                               │ HTTP
                               ▼
                    ┌──────────────────────┐
                    │    NGINX Ingress     │
                    │      Controller      │
                    └──────────┬───────────┘
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
      ┌────────────┐   ┌──────────────┐   ┌──────────────┐
      │  Frontend  │   │   Product    │   │    Order     │
      │   Nginx    │   │   Service    │   │   Service    │
      │   :8080    │   │ Flask :5000  │   │ Flask :5001  │
      └────────────┘   └──────────────┘   └──────────────┘
             │                 │                 │
             └─────────────────┴─────────────────┘
                               │
                        Kubernetes Cluster
```

---

## 🚀 Flujo DevOps / GitOps

```text
Código fuente
     │
     ▼
Docker Images
     │
     ▼
Kubernetes
     │
     ▼
Helm Chart
     │
     ▼
GitHub Repository
     │
     ▼
Argo CD
     │
     ▼
Kubernetes Sync
     │
     ▼
CloudShop
```

Git funciona como la fuente de verdad del estado deseado de la aplicación.

Argo CD compara continuamente la configuración almacenada en Git con el estado desplegado en Kubernetes.

---

## 🧩 Microservicios

| Servicio | Tecnología | Puerto | Función |
|---|---|---:|---|
| Frontend | Nginx | 8080 | Interfaz web |
| Product Service | Python / Flask | 5000 | Gestión de productos |
| Order Service | Python / Flask | 5001 | Gestión de órdenes |

### Product Service

Endpoint:

```bash
GET /products
```

Ejemplo:

```bash
curl http://192.168.49.2/api/products
```

### Order Service

Endpoint:

```bash
POST /orders
```

---

## 🐳 Docker

Cada microservicio dispone de su propia imagen Docker.

Ejemplo:

```bash
docker build -t cloudshop/frontend:v1 ./frontend
docker build -t cloudshop/product-service:v1 ./product-service
docker build -t cloudshop/order-service:v1 ./order-service
```

Durante la prueba final se creó una nueva versión del frontend:

```bash
minikube image build -t cloudshop/frontend:v2 ./frontend
```

Verificación:

```bash
minikube image ls | grep cloudshop
```

---

## ☸️ Kubernetes

CloudShop se ejecuta dentro del namespace:

```text
cloudshop
```

La aplicación utiliza:

- Deployments
- ReplicaSets
- Pods
- ClusterIP Services
- NGINX Ingress
- Namespace dedicado
- Requests y Limits de recursos
- Escalamiento horizontal mediante réplicas

Ver recursos:

```bash
kubectl get all -n cloudshop
```

---

## 🌐 Networking

La comunicación entre microservicios utiliza DNS interno de Kubernetes.

```text
frontend
product-service
order-service
```

El tráfico externo entra mediante NGINX Ingress.

| Ruta | Servicio |
|---|---|
| `/` | frontend |
| `/api/products` | product-service |
| `/api/orders` | order-service |

Ejemplo:

```bash
curl http://192.168.49.2/
curl http://192.168.49.2/api/products
```

---

## ⎈ Helm

Toda la aplicación puede desplegarse utilizando un único Helm Chart.

Estructura:

```text
helm/cloudshop/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-prod.yaml
└── templates/
```

Esto permite reutilizar el mismo Chart para diferentes ambientes.

### DEV

```bash
helm upgrade --install cloudshop ./helm/cloudshop \
  -n cloudshop \
  -f ./helm/cloudshop/values-dev.yaml
```

### PROD

```bash
helm upgrade --install cloudshop ./helm/cloudshop \
  -n cloudshop \
  -f ./helm/cloudshop/values-prod.yaml
```

---

## 🔄 GitOps con Argo CD

Argo CD administra el despliegue de CloudShop tomando GitHub como fuente de verdad.

Configuración:

```text
Repository:
github.com/jusefe11/cloudshop

Branch:
main

Path:
helm/cloudshop

Values:
values-prod.yaml

Namespace:
cloudshop
```

Flujo:

```text
Developer
    │
    │ git push
    ▼
GitHub
    │
    ▼
Argo CD
    │
    │ Detecta diferencia
    ▼
OutOfSync
    │
    │ Sync
    ▼
Kubernetes
    │
    ▼
Synced + Healthy
```

---

## 🧪 Prueba GitOps — Escalamiento

Se modificó el estado deseado del Product Service desde Git:

```yaml
product:
  replicaCount: 3
```

a:

```yaml
product:
  replicaCount: 4
```

Después del commit y sincronización mediante Argo CD:

```bash
kubectl get deployment product-service -n cloudshop
```

Resultado:

```text
NAME              READY   UP-TO-DATE   AVAILABLE
product-service   4/4     4            4
```

Esto confirmó el escalamiento declarativo mediante GitOps.

---

## 🚀 Prueba End-to-End — Frontend v2

Como prueba final se realizó un cambio real sobre el código del frontend.

### 1. Modificación

Se agregó:

```html
<h2>CloudShop - Despliegue GitOps con Argo CD</h2>
<p>Versión 2 desplegada automáticamente desde GitHub.</p>
```

### 2. Nueva imagen

```bash
minikube image build \
  -t cloudshop/frontend:v2 \
  ./frontend
```

### 3. Helm

`values-prod.yaml`:

```yaml
frontend:
  replicaCount: 2
  image:
    tag: v2
```

### 4. Git

```bash
git add .
git commit -m "Deploy frontend v2 with GitOps"
git push origin main
```

Commit utilizado:

```text
ab1fa2a Deploy frontend v2 with GitOps
```

### 5. Argo CD

Argo CD detectó el nuevo estado:

```text
Synced to main (ab1fa2a)
Sync OK
```

### 6. Kubernetes

```bash
kubectl get deployment frontend -n cloudshop
```

Resultado:

```text
frontend   2/2   2   2
```

Imagen desplegada:

```bash
kubectl get deployment frontend -n cloudshop \
  -o jsonpath='{.spec.template.spec.containers[0].image}'
```

Resultado:

```text
cloudshop/frontend:v2
```

### 7. Validación HTTP

```bash
curl http://192.168.49.2/
```

Resultado:

```html
<h2>CloudShop - Despliegue GitOps con Argo CD</h2>
<p>Versión 2 desplegada automáticamente desde GitHub.</p>
```

✅ El cambio realizado en el código llegó correctamente hasta Kubernetes utilizando el flujo GitOps.

---

## 📂 Estructura del proyecto

```text
cloudshop/
│
├── frontend/
│   ├── Dockerfile
│   └── index.html
│
├── product-service/
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
│
├── order-service/
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
│
├── k8s/
│
├── helm/
│   └── cloudshop/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-dev.yaml
│       ├── values-prod.yaml
│       └── templates/
│
└── README.md
```

---

## 🛠️ Tecnologías

- Docker
- Kubernetes
- Minikube
- Helm
- Argo CD
- Git
- GitHub
- NGINX
- Python
- Flask
- Linux

---

## 🎯 Conceptos implementados

Este laboratorio demuestra conocimientos prácticos en:

**DevOps · GitOps · Microservicios · Contenedores · Kubernetes · Helm · Argo CD · Ingress · Service Discovery · Escalamiento · Deployments · Versionamiento · Rollouts**

---

## 👨‍💻 Autor

**Juan Sebastián Ferrer Bustos**

Ingeniero Electrónico | Especialista en Seguridad Informática  
Cloud & DevOps Engineer

Proyecto desarrollado como laboratorio práctico de arquitectura DevOps, Kubernetes y GitOps.
