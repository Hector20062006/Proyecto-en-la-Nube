# Proyecto Cloud Web + LDAP (LDAPS) + Monitorización

Este proyecto define y despliega una infraestructura completa en AWS utilizando **Terraform**, gestiona la configuración de los servidores con **Ansible** y **Docker**, y automatiza el despliegue mediante pipelines de **GitHub Actions**.

## 📋 Descripción del Proyecto

El objetivo es crear un entorno seguro y escalable que incluye:

- **Infraestructura AWS (Terraform):**
  - 2 VPCs conectadas mediante Peering.
  - Instancias EC2 para servidores Web y LDAP.
  - Subredes públicas y privadas, Tablas de enrutamiento e Internet Gateways.
- **Servicios (Docker + Ansible):**
  - **Servidor Web:** Apache + PHP + Tomcat.
  - **Directorio:** OpenLDAP con soporte LDAPS (SSL/TLS).
  - **Monitorización:** Prometheus + Grafana + Exporters.
  - Autenticación centralizada vía LDAP para rutas protegidas.
- **Automatización (GitHub Actions):**
  - Despliegue automático de configuración y contenedores al hacer push a la rama `main`.

## 🏗️ Arquitectura

La infraestructura se provisiona mediante código (IaC) en la carpeta `Infraestructura/`.

- **VPC 1 (Web):** Aloja los servidores frontales accesibles desde internet.
- **VPC 2 (Backend/LDAP):** Aloja servicios internos como el directorio LDAP.
- **Peering:** Permite la comunicación privada y segura entre ambas redes.

## 🚀 Requisitos Previos

Para desplegar este proyecto necesitas:

1. **Cuenta de AWS:** Credenciales de acceso programático (Access Key y Secret Key).
2. **Terraform:** Instalado localmente para el provisionamiento inicial de la infraestructura.
3. **Dominio:** Un nombre de dominio gestionado (preferiblemente en Route53) para la generación de certificados SSL.
4. **GitHub Secrets:** Configurados en el repositorio para que funcionen las Actions.

## ⚙️ Configuración y Despliegue

### 1. Infraestructura (Terraform)

Navega a la carpeta `Infraestructura/` y configura tus variables en `terraform.tfvars` (o usa variables de entorno).

```bash
cd Infraestructura
terraform init
terraform plan
terraform apply
```

Esto creará los recursos en AWS. Asegúrate de tomar nota de las IPs públicas/privadas generadas.

### 2. Configuración de Servidores (Ansible)

La configuración de los servidores se gestiona con Ansible, ubicado en `ansible-web/`.

- **Roles:** Configuración modular para Docker, servicios web, etc.
- **Inventario:** Define tus hosts en `ansible-web/host.ini`.

### 3. Automatización (GitHub Actions)

El flujo de trabajo `.github/workflows/ansible-deploy.yml` se encarga de:

1. Construir y subir imágenes de Docker (si aplica).
2. Configurar el entorno de ejecución (instalar Ansible, SSH).
3. Desplegar los playbooks de Ansible en las instancias EC2.

#### Secretos Requeridos en GitHub:

- `AWS_ACCESS_KEY_ID`: Tu ID de clave de acceso AWS.
- `AWS_SECRET_ACCESS_KEY`: Tu clave secreta AWS.
- `AWS_REGION`: Región de despliegue (ej: us-east-1).
- `DOCKER_USERNAME`: Usuario de Docker Hub.
- `DOCKER_TOKEN`: Token de acceso o contraseña de Docker Hub.
- `ANSIBLE_PRIVATE_KEY`: La clave privada SSH (.pem) para acceder a las instancias EC2.

---

## 📂 Estructura del Repositorio

- `.github/workflows/`: Pipelines de CI/CD.
- `Infraestructura/`: Código Terraform (VPCs, Subnets, EC2, Security Groups).
- `ansible-web/`: Playbooks, roles y variables de Ansible.
- `README.MD`: Esta documentación.
