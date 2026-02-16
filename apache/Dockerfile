FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  apache2 apache2-utils \
  libapache2-mod-authnz-ldap \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN a2enmod \
  ssl headers rewrite \
  proxy proxy_http proxy_fcgi setenvif \
  authnz_ldap ldap \
  && a2dismod status

RUN ln -sf /proc/1/fd/1 /var/log/apache2/access.log \
 && ln -sf /proc/1/fd/2 /var/log/apache2/error.log

CMD ["apachectl", "-D", "FOREGROUND"]
