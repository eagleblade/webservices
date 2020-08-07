FROM php:7.4.7-fpm-alpine3.12

ENV UID=1000
ENV GID=1000
ENV USER=docker
ENV PS1="\u@\h:\w\\$ "

# install Bash, composer
RUN apk update && apk add --no-cache bash git
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home /home/$USER \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER"
    
USER $USER
# Install Symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash
USER root
RUN mv /home/docker/.symfony/bin/symfony /usr/local/bin/symfony
USER $USER
ADD entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER $USER
WORKDIR /app

CMD ["php-fpm"]

ENTRYPOINT [ "/entrypoint.sh" ]