# Postfix con Base CentOS 8.2
FROM alpine:latest

# Instalando postfix
RUN apk add --update postfix && apk add --update postfix-policyd-spf-perl && rm -rf /var/cache/apk/*

#adicionando el usuario para el uso en el spf
RUN adduser -H -D -s /sbin/nologin policyd-spf

# Creando los volumenes
VOLUME ["/etc/postfix/", "/var/log/"]

# Exponiendo el puerto 25
EXPOSE 25

# ejecución
CMD ["/usr/sbin/postfix","start"]





