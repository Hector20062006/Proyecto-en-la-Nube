FROM php:8.3-fpm-alpine

# Install dependencies for PHP extensions
RUN apk add --no-cache \
    ldb-dev \
    libldap \
    openldap-dev \
    libpng-dev \
    libzip-dev \
    icu-dev \
    oniguruma-dev

# Install PHP extensions
RUN docker-php-ext-install \
    ldap \
    mysqli \
    pdo_mysql \
    gd \
    zip \
    intl \
    opcache

# Enable error logging to stderr
RUN echo "log_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-logging.ini \
    && echo "error_log = /proc/self/fd/2" >> /usr/local/etc/php/conf.d/docker-php-ext-logging.ini
