# Postfix con Base Alpine
FROM alpine:latest

# Instalando postfix
RUN apk add --update bash postfix postfix-policyd-spf-perl busybox-extras rsyslog tzdata supervisor && rm -rf /var/cache/apk/*

# creando el folder para poner el configmap
RUN mkdir -p /etc/postfix/domains $$ chmod 755 /etc/postfix/domains

# adicionando el main.cf y master.cf
COPY *.cf /etc/postfix/

# adicionando el virtual para los virtual alias (listas)
#COPY virtual /etc/postfix/domains/

# adicionando las llaves .pem
COPY postfix_public_cert.pem /etc/ssl/certs/
COPY postfix_private_key.pem /etc/ssl/private/

# incorporando la zona horaria de Cuba
RUN  cp /usr/share/zoneinfo/Cuba /etc/localtime

# eliminando al transport por default
RUN rm -f /etc/postfix/transport && /etc/postfix/virtual

# incorporando la linea en el transport map y mapeandolo
# RUN echo "othar.cu  lmtp:[dovecot-internal-service.llanio-kubernetes.svc.cluster.local]" >> /etc/postfix/transport && echo "fuegoenterprises.cu  lmtp:[dovecot-internal-service.llanio-kubernetes.svc.cluster.local]" >> /etc/postfix/transport && mv /etc/postfix/transport /etc/postfix/domains/ && postmap /etc/postfix/domains/transport

#incorporando el relay_domains
# RUN touch /etc/postfix/domains/relay_domains && echo "othar.cu  OK" >> /etc/postfix/domains/relay_domains && echo "fuegoenterprises.cu  OK" >> /etc/postfix/domains/relay_domains && postmap /etc/postfix/domains/relay_domains

# creando nuevamente la base de datos de los alias y la base de datos de los virtual alias (listas).
# RUN postalias /etc/postfix/aliases && postmap /etc/postfix/domains/virtual
# RUN postalias /etc/postfix/aliase

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




