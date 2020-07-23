#!/bin/bash
# Create the ./nginx/nginx.conf file, using the ENVS in .env
source ./.env
WORKING_DIR=./$COMPOSE_PROJECT_NAME
# Check if the ./nginx/nginx.conf file exist
# create it or dump all the data in it.

if [ -f "$WORKING_DIR/$NGINX_CONF_FILE" ]; then
    cp /dev/null $WORKING_DIR/$NGINX_CONF_FILE
    echo "Cleaning up" $NGINX_CONF_FILE
else 
    touch $WORKING_DIR/$NGINX_CONF_FILE
    echo "Creating $NGINX_CONF_FILE"
    
fi
sleep 1
echo "
    user nginx;
    worker_processes  $WORKER_PROCESSES;

    error_log  $ERRORLOG_PATH $ERROR_LOGLEVEL;
    pid        /var/run/nginx.pid;

    events {
    worker_connections  $WORKER_CONNECTIONS;
    }


    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
                        '\$status \$body_bytes_sent \"\$http_referer\" '
                        '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';

        access_log  $ACCESSLOG_PATH  $LOG_FORMAT;

        sendfile        $SENDFILE;
        #tcp_nopush     $TCP_NOPUSH;

        keepalive_timeout  $KEEP_ALIVE_TIMEOUT;

        gzip  $GZIP;

        include /etc/nginx/conf.d/*.conf;
    }


" >> $WORKING_DIR/$NGINX_CONF_FILE

# Check if the ./nginx/app.conf file exist
# create it or dump all the data in it.

if [ -f "$WORKING_DIR/$NGINX_APP_CONF_FILE" ]; then
    cp /dev/null $WORKING_DIR/$NGINX_APP_CONF_FILE
    echo "Cleaning up" $NGINX_APP_CONF_FILE
else 
    touch $WORKING_DIR/$NGINX_APP_CONF_FILE
    echo "Creating $NGINX_APP_CONF_FILE"
fi
sleep 1
# Create the ./nginx/nginx.conf file, using the ENVS in .env

echo "
server {
    listen 80;
    index    index.html index.htm index.php;
    server_name $DOMAIN;    
    root $APP_PATH;
    

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass $DOMAIN-php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
 
    error_log /var/log/nginx/app_error.log;
    access_log /var/log/nginx/app_access.log;
}

">> $WORKING_DIR/$NGINX_APP_CONF_FILE