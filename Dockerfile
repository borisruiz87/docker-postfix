# Postfix con Base CentOS 8.2
FROM centos:centos8.2.2004

# Sustituyendo los Repo de Centos8
COPY CentOS-* /etc/yum.repos.d/

# Instalando postfix
RUN yum -y install postfix; yum clean all; sed -i "/inet_interfaces = all/s/^#//" /etc/postfix/main.cf; sed -i "/inet_interfaces = localhost/s/^/#/" /etc/postfix/main.cf

# Creando los volumenes
VOLUME ["/etc/postfix/", "/etc/pki/"]

# Exponiendo el puerto 25
EXPOSE 25

# modificando para que escuche por todas las ips


# ejecución
CMD ["/usr/sbin/postfix","start"]





