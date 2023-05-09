FROM alpine:3.16

# Instalar nginx
RUN	apk update && apk upgrade && apk add --no-cache nginx

# Declaramos que vamos a escuchar por el 443
EXPOSE 443

# Arrancamos nginx
# -g: es para una directiva de configuracion
# daemon off: que arranque en el foreground y siga abierto
CMD ["nginx", "-g", "daemon off;"]
