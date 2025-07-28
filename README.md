# PagerDuty Assignment – DevOps Take-Home Project



## Descripción general del proyecto

Este proyecto demuestra el uso de buenas prácticas DevOps para aprovisionar y gestionar infraestructura en AWS utilizando Terraform, desplegar una aplicación Angular contenedorizada con ECS y automatizar despliegues mediante pipelines CI/CD.

## Componentes de la infraestructura

- Clúster AWS ECS Fargate
- Balanceador de carga de aplicación (ALB)
- Roles IAM
- Grupos de seguridad
- VPC + subredes (a través de módulos Terraform)

## Flujo de trabajo CI/CD

- Rama develop: compila y despliega en el entorno de pruebas (test)
- Rama main: compila y despliega en el entorno de producción
- La imagen Docker se etiqueta y se sube a Docker Hub usando el nombre de la rama

## 📁 Estructura del repositorio

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml
├── app/                # Angular App
│   ├── Dockerfile
│   ├── src/
│   └── nginx/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│
├── README.md
└── .gitignore
```

## Arquitectura general

Este diagrama muestra el pipeline CI/CD basado en GitHub y la infraestructura creada con Terraform para los entornos de test y producción:

![Architecture](./images/infrastructure-devops-diagram.png)

## Cómo desplegar manualmente

Puedes desplegar este proyecto desde tu máquina local utilizando Terraform y Docker.


### 1. Requisitos previos

- Cuenta AWS con clave de acceso y clave secreta
- Terraform CLI instalado (v1.6.x o superior)
- Docker instalado (opcional, para pruebas locales)
- Angular CLI instalado (opcional)
- Un repositorio público en Docker Hub (opcional si no se usa CI/CD)

---


### 2. Clona el repositorio

```bash
git clone https://github.com/Chugague/pagerduty-assignment.git
cd pagerduty-assignment
```

### 3. Probar la app Angular localmente (opcional)

```
cd app
npm install
ng serve
```
Visit http://localhost:4200

### 4. Compilar y contenedizar la app Angular localmente (opcional)

```
docker build --build-arg BUILD_ENV=test -t pagerduty-angular:test .
docker run -p 8080:80 pagerduty-angular:test
```
Visit http://localhost:8080

### 5. Configurar credenciales AWS

Debes usar un usuario IAM con permisos para gestionar ECS, ALB, IAM y recursos de VPC. Asegúrate de tener instalado AWS CLI, luego ejecuta:

```
aws configure
```

### 6. Desplegar al entorno de pruebas

Asegúrate de tener Terraform instalado, luego ejecuta:

```
cd terraform/environments/test
terraform init
terraform apply -auto-approve
```

### 7. Destruir el entorno (para evitar cobros en AWS)

```
terraform destroy -auto-approve
```

## Cómo desplegar con el pipeline de GitHub Actions

- Push a develop → despliega en entorno de test
- Push a main → despliega en entorno de producción

### Secretos requeridos para CI/CD en GitHub

Para permitir que GitHub Actions despliegue automáticamente, se deben configurar los siguientes secretos en el repositorio:

| Secret Name              | Purpose                             |
|--------------------------|-------------------------------------|
| `DOCKERHUB_USERNAME`     | Nombre de usuario en Docker Hub     |
| `DOCKERHUB_TOKEN`        | Token de acceso a Docker Hub        |
| `AWS_ACCESS_KEY_ID`      | Clave de acceso IAM de AWS          |
| `AWS_SECRET_ACCESS_KEY`  | Clave secreta IAM de AWS            |

> 💡 Estos valores se agregan en Settings → Secrets → Actions dentro del repositorio de GitHub.


## 🔍 Vista previa en producción

A continuación se muestra un despliegue en vivo de la app desde la rama main:

![Production Preview](./images/prod-app-preview.png)


## 🔍 Nota

El entorno de producción ha sido destruido para evitar costos innecesarios en AWS.
Para volver a desplegarlo, simplemente haz push a las ramas main o develop y el pipeline CI/CD lo provisionará automáticamente.


## Autor

Kevin Ugalde  
DevOps and Software Engineer.
[github.com/Chugague](https://github.com/Chugague)