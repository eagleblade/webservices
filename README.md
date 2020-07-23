# Baro Webstack!
*For Linux only, if you want to run this on windows your on your own *

Contains a series of bash scripts, that creates all necessary files for running a NGINX docker container, that proxy PHP scripts to an PHP docker container.

The ./setup.sh will automatically create:

 - docker-compose.yaml
 - nginx/app.conf
 - nginx/nginx.conf
 - php/www.conf
 - .php.env
 - .nginx.env

and configure them according to the vars in your .env file. 

*The docker-compose file will use the baro web images, I will at a later moment publish these to git. so you can build your own images, or build from them.*

# Web Files
The www files, will be stored in /home/USERNAME/www/DOMAIN/.

    /home/$USER/www/$DOMAIN
  
This will be edited automatically by the script, and will reflect your preferences. So if your system username is bob, and your domain name are bobisthegreatest.com then the path for the web files will be 

    /home/bob/www/bobisthegreatest.com/

If you want to change this, then edit the docker-compose.yaml file, according to your preferences. Keep in mind that you have to edit both the NGINX and PHP container, or else you will have some issues.
The scripts will not create web files, or touch them! So you have to create them manually before you run the `docker-compose up -d command.`


# Docker files
All the necessary server files, as well as the docker-compose.yaml for running both NGINX and PHP will be created in a sub folder named after the `$COMPOSE_PROJECT_NAME` default: `./test_project/` so if you want to create multiply docker containers for different domains, just change the values for project name and domain, and run the scripts again

# installation
get the newest files

    git clone https://github.com/eagleblade/webservices.git

Edit the .env file first, change the 
  
	$COMPOSE_PROJECT_NAME
    $DOMAIN
    
 The rest can be left as default. 

    chmod +x *.sh
    ./setup.sh
this will create all the files in a sub-folder, go into this sub-folder and run docker-compose up -d
*By default the ports are not open, these have to be proxyed or opened manually in the docker-compose file. I use Traefik for proxy, and will add automatically configuration of traefik using file or labels at a later moment*
