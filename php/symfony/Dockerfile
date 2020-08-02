FROM php:7.4.7-fpm-alpine3.12

ENV UID=1000
ENV GID=1000
ENV USER=docker

# install Bash, composer and symfony
RUN apk update && apk add --no-cache bash git
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home /home/$USER \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER"

ENV PS1="\u@\h:\w\\$ "

USER $USER
RUN wget https://get.symfony.com/cli/installer -O - | bash
USER root
RUN mv /home/docker/.symfony/bin/symfony /usr/local/bin/symfony
USER $USER
WORKDIR /app
CMD ["php-fpm"]