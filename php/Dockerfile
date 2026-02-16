FROM php:8.3-fpm-alpine

# Install LDAP dependencies
RUN apk add --no-cache \
    ldb-dev \
    libldap \
    openldap-dev

# Install and enable LDAP PHP extension
RUN docker-php-ext-install ldap

# Enable error logging to stderr
RUN echo "log_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-logging.ini \
    && echo "error_log = /proc/self/fd/2" >> /usr/local/etc/php/conf.d/docker-php-ext-logging.ini
