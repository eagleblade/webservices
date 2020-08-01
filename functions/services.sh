function create_services(){
echo "version: \"$1\""
echo "services:"
}

function create_service_container(){
echo "    $2_$1:"
echo "      container_name: $2_$1"
echo "      hostname: $2_$1"
echo "      env_file: .$1.env"
echo "      image: docker.pkg.github.com/eagleblade/webservices/$1:latest"
echo -n "      volumes:
        - /home/$USER/www/$2:/app"
if [ $1 == "nginx" ]
then
echo "
        - ./nginx/app.conf:/etc/nginx/conf.d/default.conf:cached
        - ./nginx/nginx.conf:/etc/nginx/nginx.conf:cached
      labels:
        - traefik.http.routers.$TRAEFIK_LABELS.rule=Host(\`$2\`)
        - traefik.enable=true"
if [ $6  "True" ]
then
echo "        - traefik.http.middlewares.$TRAEFIK_LABELS-redirectscheme.redirectscheme.scheme=https
        - traefik.http.middlewares.$TRAEFIK_LABELS-redirectscheme.redirectscheme.permanent=true
        - traefik.http.routers.$TRAEFIK_LABELS.middlewares=$TRAEFIK_LABELS-redirectscheme
        - traefik.http.routers.$TRAEFIK_LABELS.tls.certresolver=cert
        - traefik.http.routers.$TRAEFIK_LABELS.tls=True"
fi
echo "        - traefik.docker.network=proxy
      networks: 
        - proxy
        - backend
      depends_on: 
        - $2_php"
fi
if [ $1 == "php" ]
then
echo "
        - ./php/www.conf:/usr/local/etc/php-fpm.d/www.conf:cached
      networks: 
        - backend"
fi
}

function create_services_network(){
echo "networks:
    proxy:
        external: true
    backend:"
}