# Proyecto Cloud Web + LDAP (LDAPS) + Monitorización

Este proyecto define y despliega una infraestructura completa en AWS, gestionando la configuración de los servidores con **Ansible** y **Docker Compose**, y automatizando el despliegue mediante **GitHub Actions**.

## 📋 Descripción

El objetivo es proporcionar un stack web seguro y monitorizado que incluye:

- **Servidor Web:** Apache (con terminación SSL y módulos de seguridad).
- **Aplicaciones:** 
  - Frontend (HTML estático).
  - Backend (PHP 8.3-FPM).
- **Seguridad:** 
  - Integración con **LDAP/LDAPS** para proteger rutas de administración.
  - Certificados SSL autofirmados (listo para Let's Encrypt).
- **Monitorización:** Stack completo con **Prometheus**, **Grafana**, **Node Exporter** y **cAdvisor**.
- **Infraestructrua como Código:** Despliegue automatizado via Ansible.

## 🏗️ Arquitectura del Repositorio

| Directorio/Archivo | Descripción |
|-------------------|-------------|
| `.github/workflows/` | Pipeline de CI/CD para desplegar en AWS al hacer push a `main`. |
| `ansible-web/` | Playbooks de Ansible y configuración de inventario (`host.ini`). |
| `apache/` | Configuración de Apache, VirtualHosts y certificados SSL. |
| `apps/` | Código fuente de las aplicaciones (Frontend y PHP). |
| `prometheus/` | Configuración de Prometheus. |
| `docker-compose.yml` | Definición de todos los servicios del stack. |
| `Infraestructura/` | (Opcional) Código Terraform para provisionar EC2/VPC. |

## 🚀 Requisitos Previos

1. **Infraestructrua AWS:** Instancias EC2 corriendo (Ubuntu 24.04 recomendado) con los puertos 80, 443, 3000 y 9090 abiertos (según necesidad).
2. **GitHub Secrets:** Debes configurar los siguientes secretos en tu repositorio para que la Action funcione:
   - `ANSIBLE_PRIVATE_KEY`: La clave privada SSH (`.pem`) para conectar a tus servidores.

## ⚙️ Despliegue Automático (GitHub Actions)

Cada vez que haces un **push** a la rama `main`, se ejecuta el flujo de trabajo:

1. **Instalación de Dependencias:** Instala Ansible en el runner de GitHub.
2. **Configuración SSH:** Configura la clave privada desde los secretos.
3. **Ejecución del Playbook:** Lanza `ansible-playbook` contra el inventario definido en `ansible-web/host.ini`.
   - Copia los archivos del proyecto a `/opt/webstack` en el servidor.
   - Levanta o actualiza los contenedores con `docker compose up -d --build`.

## 🛠️ Despliegue Manual

Si prefieres ejecutarlo desde tu máquina local:

1. Asegúrate de tener **Ansible** instalado.
2. Configura tu clave SSH (ej. `clave.pem`).
3. Ejecuta:

```bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i ansible-web/host.ini ansible-web/tasks/main.yml --private-key /ruta/a/tu/clave.pem
```

## 📊 Servicios y Puertos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **Web (HTTPS)** | 443 | Acceso a la aplicación principal y `/admin`. |
| **Web (HTTP)** | 80 | Redirecciona automáticamente a HTTPS. |
| **Grafana** | 3000 | Dashboards de monitorización (Usuario: `admin` / Password: `admin`). |
| **Prometheus** | 9090 | Servidor de métricas. |
| **cAdvisor** | 9323 | Métricas de contenedores. |

## 🔐 Variables de Entorno y Configuración

El despliegue genera automáticamente un archivo `.env` en el servidor con las variables definidas en `ansible-web/vars/main.yml`.

Variables principales:
- `domain`: Dominio del sitio web.
- `ldap_url`: URL del servidor LDAP (ej. `ldaps://...`).
- `ldap_bind_dn`: Usuario para conectar al LDAP.

---
**Nota:** El proyecto incluye certificados SSL autofirmados generados automáticamente para pruebas. Para producción, reemplaza los archivos en `apache/ssl/` con certificados válidos.
