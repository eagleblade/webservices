FROM php:7.4.7-fpm-alpine3.12
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV UID=1000
ENV GID=1000
ENV USER=debian

RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home /home/$USER \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER"

ENV PS1="\u@\h:\w\\$ "
 
RUN apk add --no-cache bash
USER $USER
CMD ["php-fpm"]