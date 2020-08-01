#!/bin/bash

#import ENVS
source .env

DOMAIN_NAME_FULL="$DOMAIN_NAME.$TLD" 
TRAEFIK_LABELS="$DOMAIN_NAME"_"$TLD"

# import functions 
#Imports all scripts from the ./function folder and source them into the script
for file in ./functions/*
do
    if [[ -f $file ]]; then
        source $file --source-only
    fi
done


if [ $# -eq 0 ]
then
        echo "Missing options!"
        echo "(run $0 -h for help)"
        echo "or $0 -f ~/docker"
        echo ""
        exit 0
fi

ECHO="false"

while getopts "hf" OPTION; do
        case $OPTION in

                f)
                        DIR="true"
                        FOLDERLOC=$2
                        ;;
                # this will be added later
                #d)
                #        DOCKER_UP="true"
                #        DOCKER_COMMAND="docker-compose -f "$2/docker-compose.yaml" up -d --build"
                #        ;;

                h)
                        echo "Usage:"
                        echo "$0 -f ~/docker"
                        echo ""
                        echo "   -f     the folder to create files for docker. Example -f ~/docker"
                     #   echo "   -cf    clear files in folder, remember to define -f"
                     #   echo "          Example: -f ~/docker -cf "
                     #   echo -e "          \e[1m\e[31mWARNING! "
                     #   echo -e "          \e[0m\e[39mThis will \e[1m\e[31mdelete \e[0m\e[39mall the files in this folder"
                     #   echo "          and create the files for docker to compose from "
                     #   echo "          in the same folder, so be carefull"
                     #   echo "   -d     create the containers runs docker-compose up -d"
                     #   echo "   -rd    remove the containers runs docker-compose down -v"                    
                        echo "   -h     help (this output)"
                        echo ""
                        exit 0
                        ;;

        esac
done

if [ $DIR = "true" ];
then
        echo "Creating the docker-compose file";
        # Create the docker-compose file
        create_folder $FOLDERLOC/$PROJECT_NAME
        create_file $FOLDERLOC/$PROJECT_NAME/docker-compose.yaml
        clear_file $FOLDERLOC/$PROJECT_NAME/docker-compose.yaml
        create_services $COMPOSE_VERSION >> $FOLDERLOC/$PROJECT_NAME/docker-compose.yaml
        create_service_container nginx $DOMAIN_NAME_FULL $IMAGE_NAME $IMAGE_VERSION $TRAEFIK_LABELS $ENABLE_TLS>> $FOLDERLOC/$PROJECT_NAME/docker-compose.yaml
        create_service_container php $DOMAIN_NAME_FULL $IMAGE_NAME $IMAGE_VERSION >> $FOLDERLOC/$PROJECT_NAME/docker-compose.yaml
        create_services_network >> $FOLDERLOC/$PROJECT_NAME/docker-compose.yaml

        # Create the config files for NGINX and PHP
        echo "Creating the config files for nginx and php";
        # create folder for nginx, create the www.conf file and clear content of it

        create_folder $FOLDERLOC/$PROJECT_NAME/nginx
        create_file $FOLDERLOC/$PROJECT_NAME/nginx/nginx.conf
        clear_file $FOLDERLOC/$PROJECT_NAME/nginx/nginx.conf
        create_file $FOLDERLOC/$PROJECT_NAME/nginx/app.conf
        clear_file $FOLDERLOC/$PROJECT_NAME/nginx/app.conf
        #build the www.conf file

        create_nginx_config >> $FOLDERLOC/$PROJECT_NAME/nginx/nginx.conf
        create_nginx_app_config $DOMAIN_NAME_FULL php /app >> $FOLDERLOC/$PROJECT_NAME/nginx/app.conf
        
        # create folder for php, create the www.conf file and clear content of it

        create_folder $FOLDERLOC/$PROJECT_NAME/php
        create_file $FOLDERLOC/$PROJECT_NAME/php/www.conf
        clear_file $FOLDERLOC/$PROJECT_NAME/php/www.conf

        #build the www.conf file

        create_www_config $DOMAIN_NAME_FULL nginx >> $FOLDERLOC/$PROJECT_NAME/php/www.conf

        # create the env files for php and nginx.
        echo "Creating the env files for both containers";
        create_file $FOLDERLOC/$PROJECT_NAME/.nginx.env
        clear_file $FOLDERLOC/$PROJECT_NAME/.nginx.env
        echo "# The envs for each of the containers are not in use as of now, but They will be created for development purposes" >> $FOLDERLOC/$PROJECT_NAME/nginx.env
        create_file $FOLDERLOC/$PROJECT_NAME/.php.env
        clear_file $FOLDERLOC/$PROJECT_NAME/.php.env
        echo "# The envs for each of the containers are not in use as of now, but They will be created for development purposes" >> $FOLDERLOC/$PROJECT_NAME/php.env

fi
