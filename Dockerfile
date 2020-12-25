FROM php:fpm
LABEL Maintainer="Son T. Tran <contact@trants.io>"
LABEL Description="Lightweight container with Nginx & PHP based on Linux."

ENV PATH="./vendor/bin:${PATH}" \
    NGINX_SERVER_NAME="_" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="6000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="128"

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        procps \
        supervisor \
        nginx \
    && docker-php-ext-install pdo pdo_mysql opcache \
    && pecl install apcu xdebug \
    && docker-php-ext-enable apcu xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

RUN mkdir /etc/nginx/ssl \
  && echo -e "\n\n\n\n\n\n\n" | openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj '/C=US/ST=State/L=Town/O=Office/CN=selfsigned' -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt

COPY config/php/php-fpm.d/docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY config/php/conf.d/*.ini /usr/local/etc/php/conf.d/
COPY config/php/php.ini /usr/local/etc/php/php.ini

COPY config/nginx/h5bp /etc/nginx/h5bp

COPY config/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/supervisor/conf.d/*.conf /etc/supervisor/conf.d-available/

RUN chown -R www-data:www-data /var/www

VOLUME /var/www

WORKDIR /var/www

EXPOSE 8000 8443
