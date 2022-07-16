# Postfix con Base Alpine
FROM alpine:latest

# Instalando postfix
RUN apk add --update bash postfix postfix-policyd-spf-perl && rm -rf /var/cache/apk/*

#adicionando el usuario para el uso en el spf
RUN adduser -H -D -s /sbin/nologin policyd-spf

# Creando los volumenes
VOLUME ["/etc/postfix/", "/var/log/", "/etc/ssl/"]

# Exponiendo el puerto 25
EXPOSE 25

# ejecución
CMD ["/usr/sbin/postfix","start"]





