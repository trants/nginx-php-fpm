FROM php:7.4-fpm-buster
MAINTAINER Son T. Tran <contact@trants.io>

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        procps \
        supervisor \
        nginx \
        libicu-dev\
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql intl \
    && pecl install redis apcu xdebug-2.9.8 \
    && docker-php-ext-enable apcu xdebug redis

RUN mkdir /etc/nginx/ssl \
  && echo -e "\n\n\n\n\n\n\n" | openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj '/C=US/ST=State/L=Town/O=Office/CN=selfsigned' -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt

COPY nginx/h5bp /etc/nginx/h5bp

COPY php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY php/conf.d/*.ini /usr/local/etc/php/conf.d/
COPY php/php.ini /usr/local/etc/php/php.ini
COPY php/composer-installer.sh /usr/local/bin/composer-installer

COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor/conf.d/*.conf /etc/supervisor/conf.d-available/

COPY entrypoint-run-app.sh /usr/local/bin/entrypoint-run-app

RUN chmod +x /usr/local/bin/entrypoint-run-app \
    && chmod +x /usr/local/bin/composer-installer \
    && /usr/local/bin/composer-installer \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

RUN chown -R www-data:www-data /var/www

VOLUME /var/www

WORKDIR /var/www

EXPOSE 8000 8443

CMD ["/usr/local/bin/entrypoint-run-app"]
