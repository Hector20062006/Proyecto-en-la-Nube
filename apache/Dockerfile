FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar Apache y utilidades
RUN apt-get update && apt-get install -y \
  apache2 apache2-utils \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Copiar certificados SSL dentro de la imagen
# IMPORTANTE: Esto requiere que existan apache/ssl/fullchain.pem y privkey.pem
COPY ssl/ /etc/apache2/ssl/

# Habilitar módulos necesarios
RUN a2enmod \
  ssl headers rewrite \
  proxy proxy_http proxy_fcgi setenvif \
  authnz_ldap ldap \
  && a2dismod status

# Redirigir logs a stdout/stderr
RUN ln -sf /proc/1/fd/1 /var/log/apache2/access.log \
  && ln -sf /proc/1/fd/2 /var/log/apache2/error.log

# Exponer puertos estándar
EXPOSE 80 443

# Arrancar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]
