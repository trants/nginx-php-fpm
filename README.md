## NGINX-PPH-FPM Docker Image

A docker library using Nginx and PHP-FPM. This library is an opinionated approach to organizing Docker in a PHP project and demonstrates separating configuration and code for containers.

## Code Organization
Here is a quick overview of the Docker setup files:
```
nginx-php-fpm
├── Dockerfile
├── entrypoint-run-app.sh
├── nginx
│   └── h5bp
│       ├── directive-only
│       │   ├── cache-file-descriptors.conf
│       │   ├── cross-domain-insecure.conf
│       │   ├── extra-security.conf
│       │   ├── no-transform.conf
│       │   ├── ssl.conf
│       │   ├── ssl-stapling.conf
│       │   └── x-ua-compatible.conf
│       ├── location
│       │   ├── cache-busting.conf
│       │   ├── cross-domain-fonts.conf
│       │   ├── expires.conf
│       │   └── protect-system-files.conf
│       └── basic.conf
├── php
│   ├── conf.d
│   │    └── xdebug.ini
│   ├── php-fpm.d
│   │    └── zz-docker.conf
│   ├── composer-installer.sh
│   └── php.ini
└── supervisor
    ├── conf.d
    │   └── application.conf
    └── supervisord.conf
```
