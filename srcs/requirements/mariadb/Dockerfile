FROM alpine:3.16

# Argumentos para la construcción de la db
ARG DB_NAME \
    DB_USER \
    DB_PASS

# Instalamos mariadb
RUN apk update && apk add --no-cache mariadb mariadb-client

# Creamos el directorio y el archivo docker.cnf y habilitamos networking
# al final creamos la db
RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } > /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf; \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Declaramos que vamos a escuchar por el 3306
EXPOSE 3306

# Copiamos y ejecutamos el script
COPY requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh

# A partir de ahora los comandos se ejecutan con este usuario
USER mysql

CMD ["/usr/bin/mysqld", "--skip-log-error"]
