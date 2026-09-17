# ☁️ CloudShop — AWS DevOps & GitOps Lab

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonwebservices)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?logo=terraform)
![Docker](https://img.shields.io/badge/Docker-Containers-blue?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-blue?logo=kubernetes)
![Helm](https://img.shields.io/badge/Helm-Package_Manager-blue?logo=helm)
![ArgoCD](https://img.shields.io/badge/Argo_CD-GitOps-orange?logo=argo)
![GitHub](https://img.shields.io/badge/GitHub-Repository-black?logo=github)
![Nginx](https://img.shields.io/badge/Nginx-Frontend-green?logo=nginx)
![Python](https://img.shields.io/badge/Python-Flask-yellow?logo=python)

CloudShop es un laboratorio práctico de **Cloud, DevOps y GitOps** basado en una arquitectura de microservicios.

El proyecto comenzó ejecutándose localmente sobre Kubernetes con Docker, Helm y Argo CD, y actualmente está evolucionando hacia una arquitectura en **AWS administrada mediante Terraform y automatizada con GitHub Actions**.

---

## 🏗️ Arquitectura actual

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
      ┌────────────┐    ┌──────────────┐   ┌──────────────┐
      │  Frontend  │    │   Product    │   │    Order     │
      │   Nginx    │    │   Service    │   │   Service    │
      │   :8080    │    │ Flask :5000  │   │ Flask :5001  │
      └────────────┘    └──────────────┘   └──────────────┘
                               │
                               ▼
                      Kubernetes Cluster
```

---

## ☁️ Evolución hacia AWS

La siguiente etapa del laboratorio incorpora infraestructura Cloud en AWS utilizando Terraform.

```text
Developer
    │
    │ git push
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    │ OIDC
    ▼
AWS IAM Role
    │
    ▼
Terraform
    │
    ▼
AWS
    │
    ├── VPC
    ├── Public Subnet
    ├── Private Subnet
    ├── Internet Gateway
    ├── Route Tables
    └── Security Groups
```

La infraestructura se define mediante **Infrastructure as Code (IaC)**, permitiendo crear ambientes reproducibles y versionados.

Actualmente el módulo base de networking contiene:

- VPC
- Subnet pública
- Subnet privada
- Internet Gateway
- Route Table
- Route Table Association
- Security Group

---

## 🧩 Microservicios

| Servicio | Tecnología | Puerto | Función |
|---|---|---:|---|
| Frontend | Nginx | 8080 | Interfaz web |
| Product Service | Python / Flask | 5000 | Gestión de productos |
| Order Service | Python / Flask | 5001 | Gestión de órdenes |

### Product Service

```bash
GET /products
```

Ejemplo:

```bash
curl http://192.168.49.2/api/products
```

### Order Service

```bash
POST /orders
```

---

## 🐳 Docker

Cada microservicio dispone de su propia imagen Docker.

```bash
docker build -t cloudshop/frontend:v1 ./frontend

docker build -t cloudshop/product-service:v1 ./product-service

docker build -t cloudshop/order-service:v1 ./order-service
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
- Requests y Limits
- Escalamiento mediante réplicas

Ver recursos:

```bash
kubectl get all -n cloudshop
```

---

## 🌐 Networking Kubernetes

La comunicación entre microservicios utiliza el DNS interno de Kubernetes.

```text
frontend
product-service
order-service
```

El tráfico HTTP se enruta mediante NGINX Ingress.

| Ruta | Servicio |
|---|---|
| `/` | frontend |
| `/api/products` | product-service |
| `/api/orders` | order-service |

---

## ⎈ Helm

La aplicación puede desplegarse utilizando un único Helm Chart.

```text
helm/cloudshop/

├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-prod.yaml
└── templates/
```

Esto permite reutilizar el mismo Chart para diferentes ambientes.

Ejemplo DEV:

```bash
helm upgrade --install cloudshop ./helm/cloudshop \
  -n cloudshop \
  -f ./helm/cloudshop/values-dev.yaml
```

---

## 🔄 GitOps con Argo CD

Argo CD administra el estado deseado de CloudShop utilizando GitHub como fuente de verdad.

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
    │ Detecta cambios
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

Repositorio:

```text
github.com/jusefe11/cloudshop
```

Branch:

```text
main
```

Path:

```text
helm/cloudshop
```

---

# 🟣 Terraform — Infrastructure as Code

La infraestructura AWS se administra mediante Terraform.

Estructura actual:

```text
terraform/
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── qa/
│   └── prod/
│
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

El diseño separa los **módulos reutilizables** de la configuración específica de cada ambiente.

### Validación Terraform

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

El módulo VPC actualmente genera un plan de:

```text
Plan: 7 to add, 0 to change, 0 to destroy.
```

> Por seguridad y control de costos, esta etapa del laboratorio valida la infraestructura con `terraform plan` sin ejecutar `terraform apply`.

---

## 🔐 Seguridad

El proyecto aplica buenas prácticas como:

- Separación de subnets públicas y privadas.
- Security Groups.
- Variables sensibles excluidas de Git.
- Estados Terraform excluidos del repositorio.
- `.terraform/` excluido del repositorio.
- Uso progresivo de IAM con mínimo privilegio.
- Integración prevista de GitHub Actions con AWS mediante OIDC.
- Sin credenciales permanentes de AWS almacenadas en GitHub.

---

## 🚀 CI/CD

La siguiente etapa incorpora GitHub Actions.

```text
Developer
    │
    │ git push
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ├── terraform fmt
    ├── terraform init
    ├── terraform validate
    └── terraform plan
    │
    ▼
AWS mediante OIDC
```

Posteriormente el pipeline evolucionará para construir imágenes Docker y publicarlas en Amazon ECR.

---

## 🎯 Roadmap AWS

```text
Terraform
   │
   ├── VPC              ✅ Código creado
   │
   ├── Subnets          ✅ Código creado
   │
   ├── Internet Gateway ✅ Código creado
   │
   ├── Route Tables     ✅ Código creado
   │
   ├── Security Groups  ✅ Código creado
   │
   ├── IAM / OIDC       ⏳
   ├── ECR              ⏳
   ├── EKS              ⏳
   ├── RDS              ⏳
   ├── ALB              ⏳
   ├── CloudWatch       ⏳
   ├── SQS / SNS        ⏳
   └── Lambda           ⏳
```

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
│
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── qa/
│   │   └── prod/
│   │
│   └── modules/
│       └── vpc/
│
└── README.md
```

---

## 🛠️ Tecnologías

**Cloud:** AWS  
**IaC:** Terraform  
**Containers:** Docker  
**Orchestration:** Kubernetes / Minikube  
**Package Manager:** Helm  
**GitOps:** Argo CD  
**CI/CD:** GitHub Actions  
**Frontend:** NGINX  
**Backend:** Python / Flask  
**Version Control:** Git / GitHub  
**Operating System:** Linux

---

## 🎯 Conceptos implementados

**DevOps · GitOps · AWS · Infrastructure as Code · Terraform · Microservicios · Docker · Kubernetes · Helm · Argo CD · Ingress · Service Discovery · Networking · IAM · CI/CD · Escalamiento · Versionamiento**

---

## 👨‍💻 Autor

**Juan Sebastián Ferrer Bustos**

Ingeniero Electrónico | Especialista en Seguridad Informática  
Cloud & DevOps Engineer

Proyecto desarrollado como laboratorio práctico de **Cloud Computing, AWS, DevOps, Kubernetes, Terraform y GitOps**.