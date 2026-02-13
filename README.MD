# Cloud Web + LDAP (LDAPS) + Monitoring (Prometheus/Grafana) con Terraform + Docker + GitHub Actions

## Objetivo
Infraestructura en AWS:
- 2 VPC con peering
- EC2 Web en subred pública (contenedores: Apache + PHP + Tomcat)
- EC2 LDAP en subred privada (OpenLDAP con LDAPS)
- Certificados Let's Encrypt (DNS-01 recomendado)
- Autenticación LDAP en Apache para rutas protegidas (/admin)
- Monitorización: Prometheus + Grafana + exporters
- Deploy automatizado con GitHub Actions vía SSM

## Requisitos
- AWS account + credenciales para Terraform
- Un dominio y (idealmente) Route53 Hosted Zone
- GitHub repo con Secrets:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_REGION
  - ECR_REPOSITORY (p.ej. cloud-web-ldap)
  - TF_STATE_BUCKET (si usas backend remoto opcional)

