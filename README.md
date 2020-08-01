

# Baro Webstack!

# Installation
    ./setup.sh -f ~/docker
For more options run

    ./setup.sh -h

The script will by default create the following files and folders.

    /home/$USER/docker/test/
						    ./.nginx.env
						    ./.php.env
						    ./docker-compose.yaml
						    ./nginx
							    ./app.conf
							    ./nginx.conf
						    ./php
							    ./www.conf

The default location for web-files will be 

    /home/$USER/www/test.com

If you want to change this, just edit the docker-compose file. **(google will show you how!)**

It's importain't that you at-least change the **DOMAIN_NAME** and perhaps the **PROJECT_NAME**

    PROJECT_NAME="test"
    COMPOSE_VERSION="3.8"
    IMAGE_VERSION="latest"
    DOMAIN_NAME="test.com"
    ENABLE_TLS="True"  #True to enable SSL
    TRAEFIK_LABELS="${DOMAIN_NAME//./_}"
    DOMAIN_NAME_FULL="$DOMAIN_NAME"

*The script will add labels for [traefik](https://docs.traefik.io/)*

**these labels are:**

    - traefik.http.routers.com.rule=Host(`test.com`)
    - traefik.enable=true
    - traefik.docker.network=proxy

**if you set ENABLE_TLS to True the script will also add**

    - traefik.http.middlewares.com-redirectscheme.redirectscheme.scheme=https
    - traefik.http.middlewares.com-redirectscheme.redirectscheme.permanent=true
    - traefik.http.routers.com.middlewares=com-redirectscheme
    - traefik.http.routers.com.tls.certresolver=cert
    - traefik.http.routers.com.tls=true

**Add this to your traefik.toml to get the certs to work!**
*More info about this can be found [here](https://docs.traefik.io/https/acme/)*

    [certificatesResolvers.cert.acme]
      email = "your@email.address"
      storage = "domains/acme.json"
      caServer = "https://acme-v02.api.letsencrypt.org/directory"
      [certificatesResolvers.cert.acme.tlsChallenge]
        [certificatesResolvers.cert.acme.httpChallenge]
        # used during the challenge
        entryPoint = "http"

Good luck!
