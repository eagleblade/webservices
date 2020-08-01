#!/bin/bash
function create_www_config(){
echo "[www]
 
user = www-data
group = www-data
 
listen = $1_$2:9000
 
pm = dynamic
pm.max_children = 40
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 4
pm.max_requests = 500

"
}

function create_nginx_config(){
echo "
    user nginx;
    worker_processes  auto;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;

    events {
    worker_connections  1024;
    }


    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
                        '\$status \$body_bytes_sent \"\$http_referer\" '
                        '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;
        #tcp_nopush     on;

        keepalive_timeout  65;

        gzip  on;

        include /etc/nginx/conf.d/*.conf;
    }




"
}
function create_nginx_app_config(){
echo "server {
    listen 80;
    index    index.html index.htm index.php;
    server_name $1;    
    root $3;
    

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass $1_$2:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
 
    error_log /var/log/nginx/app_error.log;
    access_log /var/log/nginx/app_access.log;
}
"
}
