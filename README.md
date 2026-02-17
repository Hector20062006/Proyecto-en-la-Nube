# ☁️ Proyecto Cloud de Despliegue Automatizado

Este proyecto implementa una infraestructura robusta y escalable en **AWS**, diseñada bajo los principios de **DevOps** e **Infraestructura como Código (IaC)**. El objetivo es ofrecer un stack web completo, seguro y monitorizado, desplegado de forma 100% automatizada mediante **GitHub Actions**.

La arquitectura combina la flexibilidad de **Docker**, la gestión de configuración de **Ansible** y la seguridad centralizada de **LDAP**.

---

## 📖 Tabla de Contenidos

1. [Arquitectura del Sistema](#-arquitectura-del-sistema)
2. [Tecnologías Utilizadas](#-tecnologías-utilizadas)
3. [Estructura del Repositorio](#-estructura-del-repositorio)
4. [Requisitos Previos](#-requisitos-previos)
5. [Flujo de Trabajo (CI/CD)](#-flujo-de-trabajo-cicd)
6. [Guía de Despliegue Manual](#-guía-de-despliegue-manual)
7. [Monitorización y Métricas](#-monitorización-y-métricas)

---

## 🏗 Arquitectura del Sistema

El sistema utiliza una arquitectura de microservicios contenerizados sobre instancias EC2, garantizando aislamiento y facilidad de escalado.

### Flujo de Tráfico

1.  **Seguridad Web (HTTPS 443)**:
    - Todo el tráfico es encriptado. Apache fuerza la redirección de HTTP a HTTPS.
    - **Certificados SSL Autosignados**: Generados automáticamente durante el despliegue para garantizar encriptación desde el primer momento.

2.  **Enrutamiento Inteligente**:
    - **Frontend (`/`)**: Sirve contenido estático (HTML/JS) de alto rendimiento.
    - **Backend (`/phpapp`)**: Las peticiones dinámicas se redirigen al contenedor **PHP-FPM** vía FastCGI (puerto 9000).
    - **Panel de Administración (`/admin`)**: Área restringida protegida mediante autenticación **LDAP/LDAPS**.

3.  **Observabilidad**:
    - **Prometheus**: Recolector de métricas de series temporales.
    - **Grafana**: Visualización en tiempo real del estado de la infraestructura.

---
### Topología de Red (Terraform)

La base de la infraestructura se despliega mediante **Terraform**, creando un entorno de red seguro y segmentado:

*   **Doble VPC con Peering**: Se despliegan dos Virtual Private Clouds (`vpc-1`, `vpc-2`) interconectadas mediante **VPC Peering**, permitiendo comunicación privada de baja latencia entre ellas.
*   **Segmentación de Subredes**:
    *   **Públicas**: Alojan componentes accesibles desde internet (NAT Gateways, Load Balancers).
    *   **Privadas**: Alojan las instancias de cómputo (EC2) y bases de datos, sin acceso directo desde el exterior.
*   **Enrutamiento y Salida a Internet**:
    *   **Internet Gateways (IGW)**: Para las subredes públicas.
    *   **NAT Gateways**: Permiten a las instancias en subredes privadas acceder a internet (ej. para actualizaciones) sin exponerse a conexiones entrantes.

---
## 🛠 Tecnologías Utilizadas

| Tecnología | Descripción y Uso |
|------------|-------------------|
| **Terraform** | Infraestructura como Código (IaC) para red y seguridad. |
| **AWS EC2** | Plataforma de cómputo en la nube (Ubuntu 24.04). |
| **Docker Compose** | Orquestación de servicios (Web, App, LDAP, Monitoring). |
| **Ansible** | Aprovisionamiento de servidores y gestión de configuraciones idempotentes. |
| **GitHub Actions** | Pipeline de CI/CD para integración y despliegue continuo. |
| **Apache 2.4** | Servidor Web y Proxy Inverso con módulos SSL y LDAP. |
| **PHP 8.3** | Entorno de ejecución FPM para aplicaciones dinámicas. |
| **OpenLDAP** | Directorio de usuarios para autenticación centralizada. |
| **Prometheus/Grafana** | Stack de monitorización y observabilidad. |

---

## 📂 Estructura del Repositorio

El proyecto sigue una estructura limpia y modular:

```plaintext
.
├── .github/workflows/    # Definición del pipeline de CI/CD (ansible-deploy.yml)
├── ansible-web/          # Lógica de automatización con Ansible
│   ├── tasks/            # Tareas principales (instalar docker, deploy, ssl)
│   ├── templates/        # Plantillas Jinja2 para configuraciones dinámicas
│   └── vars/             # Variables de entorno y configuración
├── apache/               # Dockerfile y configuraciones del servidor web
├── php/                  # Dockerfile con extensiones personalizadas
├── apps/                 # Código fuente de las aplicaciones (Frontend, PHP)
├── ldap/                 # Stack independiente para el servidor LDAP
├── prometheus/           # Configuración de métricas y scraping
└── docker-compose.yml    # Definición de servicios y redes
```

---

## 🚀 Requisitos Previos

Para desplegar este proyecto, asegúrate de tener configurado lo siguiente:

### Secretos de GitHub
Configura estos secretos en tu repositorio para permitir el acceso de Ansible:
- `ANSIBLE_PRIVATE_KEY`: Tu clave SSH privada (`.pem`) con acceso a las instancias EC2.

### Security Groups (AWS)
Asegúrate de permitir el tráfico en los siguientes puertos:
- **22 (SSH)**: Para la gestión (restringir a tu IP).
- **80/443 (HTTP/HTTPS)**: Acceso público a la web.
- **3000**: Acceso al dashboard de Grafana.
- **9090**: Acceso a Prometheus (opcional).

---

## 🔄 Flujo de Trabajo (CI/CD)

El pipeline de despliegue se activa automáticamente con cada **Push** a la rama `main`:

1.  **Configuración del Entorno**: GitHub Actions prepara el runner e instala las dependencias de Ansible.
2.  **Aprovisionamiento con Ansible**:
    - Conecta a las instancias EC2 definidas en el inventario.
    - Elimina contenedores y volúmenes antiguos para asegurar un despliegue limpio.
    - Genera certificados SSL frescos en el servidor.
    - Configura el entorno usando plantillas (`.env`, configs de Apache).
3.  **Despliegue de Contenedores**:
    - Construye las imágenes de Docker optimizadas.
    - Levanta los servicios (`docker compose up -d`).
4.  **Verificación**:
    - Realiza comprobaciones de salud para asegurar que el servidor responde correctamente.

---

## 🛠 Guía de Despliegue Manual

Si prefieres realizar un despliegue manual desde tu máquina local (saltando GitHub Actions):

```bash
# 1. Instalar Ansible
sudo apt update && sudo apt install -y ansible

# 2. Clonar el repositorio
git clone <url-del-repo>
cd Proyecto-en-la-Nube

# 3. Ejecutar el Playbook
# Asegúrate de tener tu clave .pem y actualizar el archivo host.ini con la IP correcta
ansible-playbook -i ansible-web/host.ini ansible-web/tasks/main.yml \
  --private-key /ruta/a/tu-clave.pem
```

---

## 📈 Monitorización y Métricas

La infraestructura incluye un stack de monitorización completo accesible vía navegador.

- **Grafana**: `http://<IP-SERVIDOR>:3000`
    - Credenciales por defecto: `admin` / `admin`
    - Dashboards preconfigurados para visualizar métricas de sistema y contenedores.

- **Prometheus**: `http://<IP-SERVIDOR>:9090`
    - Interfaz para consultas de métricas en crudo (PromQL).

---

## 🔐 Despliegue de LDAP (Stack Independiente)

El servidor LDAP se gestiona como un componente independiente para mayor seguridad y persistencia.

1.  Transfiere la carpeta `ldap/` al servidor.
2.  Ejecuta el script de instalación automática:
    ```bash
    cd ldap
    chmod +x setup.sh
    ./setup.sh
    ```

Esto levantará un servidor OpenLDAP configurado con SSL (`ldaps://`) y una estructura de usuarios base definida en `bootstrap/data.ldif`.

**Credenciales de Admin LDAP:**
- **DN**: `cn=admin,dc=hector,dc=local`
- **Contraseña**: (Definida en tu archivo `.env` o script de setup)

---

**Proyecto Cloud Computing** | Infraestructura Automatizada y Segura.
Hecho con mucho cariño