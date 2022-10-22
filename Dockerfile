# Postfix con Base Alpine
FROM alpine:latest

# Instalando postfix
RUN apk add --update bash postfix postfix-policyd-spf-perl busybox-extras rsyslog supervisor && rm -rf /var/cache/apk/*

# adicionando el main.cf y master.cf
COPY *.cf /etc/postfix/

# adicionando las llaves .pem
COPY postfix_public_cert.pem /etc/ssl/certs/
COPY postfix_private_key.pem /etc/ssl/private/

# incorporando la linea en el transport map y mapeandolo
RUN echo "othar.cu  lmtp:[dovecot]" >> /etc/postfix/transport && postmap /etc/postfix/transport

# creando nuevamente la base de datos de los alias.
RUN postalias /etc/postfix/aliases

#adicionando el usuario para el uso en el spf
RUN adduser -H -D -s /sbin/nologin policyd-spf

# Creando los volumenes
VOLUME ["/var/log/"]

# Exponiendo el puerto 25
EXPOSE 25

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["sh","-c","/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]




