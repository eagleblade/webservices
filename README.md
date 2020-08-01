
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

It's importain't that you atleast change the **TLD** and the **DOMAIN_NAME**

    PROJECT_NAME="test"
    COMPOSE_VERSION="3.8"
    IMAGE_NAME="baro"
    IMAGE_VERSION="latest"
    DOMAIN_NAME="test"
    TLD="com"
    ENABLE_TLS="False" #True to enable SSL
Change **PROJECT_NAME**, **DOMAIN_NAME** and **TLD**. The rest should be left as default.
if your domain name is bobisthegreatest.com then the .env file should look something like this

    PROJECT_NAME="bob"
    COMPOSE_VERSION="3.8"
    IMAGE_NAME="baro"
    IMAGE_VERSION="latest"
    DOMAIN_NAME="bobisthegreatest"
    TLD="com"
    ENABLE_TLS="False" #True to enable SSL

*The script will add labels for [traefik](https://docs.traefik.io/)*

**these labels are:**

    - traefik.http.routers.com.rule=Host(`test.com`)
    - traefik.enable=true
    - traefik.docker.network=proxy

**if you change ENABLE_TLS to True the script will also add**

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
