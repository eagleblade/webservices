FROM php:7.4.7-fpm-alpine3.12

ENV UID=1000
ENV GID=1000
ENV USER=docker
ENV PS1="\u@\h:\w\\$ "

RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home /home/$USER \
    --ingroup "$USER" \
    --uid "$UID" \
    "$USER"
    
USER $USER
WORKDIR /app
CMD ["php-fpm"]