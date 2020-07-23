#!/bin/bash
source ./.env

echo "creating services"
sleep 1

if [ -d "$COMPOSE_PROJECT_NAME" ]; then
    sleep 1
else 
    mkdir $COMPOSE_PROJECT_NAME
    echo "Creating $COMPOSE_PROJECT_NAME"
fi

./services.sh
sleep 1

echo "NGINX Configurations"
sleep 1
if [ -d "$COMPOSE_PROJECT_NAME/nginx" ]; then
    sleep 1
else 
    mkdir $COMPOSE_PROJECT_NAME/nginx
    echo "Creating $COMPOSE_PROJECT_NAME/nginx"
fi


./nginx.sh
sleep 1

echo "PHP Configurations"
sleep 1
if [ -d "$COMPOSE_PROJECT_NAME/php" ]; then
    sleep 1
else 
    mkdir $COMPOSE_PROJECT_NAME/php
    echo "Creating $COMPOSE_PROJECT_NAME/php"
fi


./php.sh
sleep 1
echo "ENV Configurations"
sleep 1
# create the ENV file, for the project Directory
./envs.sh
sleep 1
