#!/bin/bash
source ./.env
WORKING_DIR=./$COMPOSE_PROJECT_NAME

if [ -f "$WORKING_DIR/$PHP_CONF_FILE" ]; then
    cp /dev/null $WORKING_DIR/$PHP_CONF_FILE
    echo "Cleaning up" $PHP_CONF_FILE
else 
    touch $WORKING_DIR/$PHP_CONF_FILE
    echo "Creating $PHP_CONF_FILE"
fi

echo "
[www]
 
user = www-data
group = www-data
 
listen = $DOMAIN-nginx:9000
 
pm = dynamic
pm.max_children = 40
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 4
pm.max_requests = 500
" >> $WORKING_DIR/$PHP_CONF_FILE