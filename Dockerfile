# Postfix con Base Alpine
FROM alpine:latest

# Instalando postfix
RUN apk add --update bash postfix postfix-policyd-spf-perl busybox-extras rsyslog tzdata supervisor && rm -rf /var/cache/apk/*

# creando el folder para poner el configmap
RUN mkdir -p /etc/postfix/domains

# adicionando el main.cf y master.cf
COPY *.cf /etc/postfix/

# adicionando las llaves .pem
COPY postfix_public_cert.pem /etc/ssl/certs/
COPY postfix_private_key.pem /etc/ssl/private/

# incorporando la zona horaria de Cuba
RUN  cp /usr/share/zoneinfo/Cuba /etc/localtime

# eliminando al transport por default
RUN rm -f /etc/postfix/transport && rm -f /etc/postfix/virtual

#adicionando el usuario para el uso en el spf
RUN adduser -H -D -s /sbin/nologin policyd-spf

# Creando los volumenes
VOLUME ["/etc/postfix/domains/", "/var/log/"]

# Exponiendo el puerto 25
EXPOSE 25

# ejecutando el mapeo del relay_domains, virtual, aliase, transport
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["sh","-c","/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]




