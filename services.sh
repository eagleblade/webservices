#!/bin/bash
source ./.env
WORKING_DIR=./$COMPOSE_PROJECT_NAME
if [ -f "$WORKING_DIR/$DOCKER_FILE" ]; then
    cp /dev/null $WORKING_DIR/$DOCKER_FILE
    echo "Cleaning up" $DOCKER_FILE
else 
    touch $WORKING_DIR/docker-compose.yaml
    echo "Creating $WORKING_DIR/$DOCKER_FILE"
fi

# Create the docker-compose file, using the ENVS in .env
echo "version: \"3\"

services:
    $DOMAIN-nginx:
        env_file: $ENV_NGINX_CONFIG_FILE
        image: $REPOSITORY_NAME/nginx:$IMAGE_TAG
        container_name: $DOMAIN-nginx
        hostname: $DOMAIN-nginx
        volumes: 
            - $BASE_URL/$USER/$WEB_ROOT/$DOMAIN:$APP_PATH
            - ./nginx/app.conf:/etc/nginx/conf.d/default.conf:cached
            - ./nginx/nginx.conf:/etc/nginx/nginx.conf:cached
        working_dir: $APP_PATH
        networks: 
            - $NETBACK
            - $PROXYNET
        depends_on:
            - $DOMAIN-php
    $DOMAIN-php:
        env_file: $ENV_PHP_CONFIG_FILE
        image: $REPOSITORY_NAME/php:$IMAGE_TAG
        container_name: $DOMAIN-php
        hostname: $DOMAIN-php
        volumes: 
            - $BASE_URL/$USER/$WEB_ROOT/$DOMAIN:$APP_PATH
            - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf:cached
        networks:
            - $NETBACK

networks:
    $PROXYNET:
        external: true
    $NETBACK:

">> $WORKING_DIR/$DOCKER_FILE
