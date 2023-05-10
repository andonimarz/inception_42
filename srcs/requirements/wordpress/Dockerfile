FROM alpine:3.16

# Argumentos para la construcción del wp
ARG DOMAIN_NAME \
    DB_NAME \
    DB_USER \
    DB_PASS \
    WP_ADMIN_USER \
    WP_ADMIN_PASSWORD \
    WP_ADMIN_EMAIL

# Instalamos paquetes de php y wp-cli para install.sh
RUN apk update && apk upgrade && apk add --no-cache \
    php8 php8-fpm php8-gd php8-mysqli php8-xml php8-dom \
    php8-mbstring php8-phar php8-curl wget unzip && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp

# Modificamos www.conf de php
RUN sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" /etc/php8/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

# Instalamos wordpress
WORKDIR /var/www
RUN wget https://wordpress.org/latest.zip && unzip latest.zip && \
    cp -rf wordpress/* . && rm -rf wordpress latest.zip

# Copiamos y ejecutamos el script que configura wp
COPY ./requirements/wordpress/conf/wp-config-create.sh .
RUN sh wp-config-create.sh && rm wp-config-create.sh && \
    chmod -R 0777 wp-content/ 

# Copiamos y transferimos las variables al script que instala el core
COPY ./requirements/wordpress/conf/install.sh .
RUN chmod +x install.sh && \
    sed -i "s|domain_here|${DOMAIN_NAME}|g" install.sh && \
    sed -i "s|wp_admin_user_here|${WP_ADMIN_USER}|g" install.sh && \
    sed -i "s|wp_admin_password_here|${WP_ADMIN_PASSWORD}|g" install.sh && \
    sed -i "s|wp_admin_email_here|${WP_ADMIN_EMAIL}|g" install.sh

# Ejecutamos install.sh indicando con -c que es un comando
# Iniciamos el daemon de PHP-FPM
# -F es para que lo haga en el foreground y se quede abierto
CMD ["sh", "-c", "./install.sh && /usr/sbin/php-fpm8 -F"]
