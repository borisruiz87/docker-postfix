# Postfix con Base Alpine
FROM alpine:latest

# Instalando postfix
RUN apk add --update bash postfix postfix-policyd-spf-perl opendkim opendkim-utils && rm -rf /var/cache/apk/*

# adicionando el main.cf y master.cf
COPY *.cf /etc/postfix/

# Add configs del DKIM
ADD ./etc/ /etc/

# dando permisos al directorio de dkim
RUN chown -R opendkim:opendkim /etc/opendkim/keys/

# incorporando la linea en el transport map y mapeandolo
RUN echo "mycubantrip.com  lmtp:[dovecot]" >> /etc/postfix/transport && postmap /etc/postfix/transport

#adicionando el usuario para el uso en el spf
RUN adduser -H -D -s /sbin/nologin policyd-spf

#adicionando el usuario postfix al grupo opendkim
RUN addgroup postfix opendkim

# Creando los volumenes
VOLUME ["/etc/postfix/", "/var/log/", "/etc/ssl/", "/etc/opendkim"]

# Exponiendo el puerto 25
EXPOSE 25

# ejecución
CMD ["sh","-c","/usr/sbin/postfix start-fg"]





