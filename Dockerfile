# Postfix con Base Alpine
FROM alpine:latest

# Instalando postfix
RUN apk add --update bash postfix postfix-policyd-spf-perl busybox-extras rsyslog && rm -rf /var/cache/apk/*

# adicionando el main.cf y master.cf
COPY *.cf /etc/postfix/

# adicionando las llaves .pem
COPY postfix_public_cert.pem /etc/ssl/certs/
COPY postfix_private_key.pem /etc/ssl/private/

# incorporando la linea en el transport map y mapeandolo
RUN echo "mycubantrip.com  lmtp:[dovecot]" >> /etc/postfix/transport && postmap /etc/postfix/transport

# creando nuevamente la base de datos de los alias.
RUN postalias /etc/postfix/aliases

#adicionando el usuario para el uso en el spf
RUN adduser -H -D -s /sbin/nologin policyd-spf

# Creando los volumenes
VOLUME ["/var/log/"]

# Exponiendo el puerto 25
EXPOSE 25

COPY my_wrapper_script.sh my_wrapper_script.sh
CMD ["sh","-c","./my_wrapper_script.sh"]

# ejecución
#CMD ["sh","-c","rsyslogd -n && /usr/sbin/postfix start-fg"]





