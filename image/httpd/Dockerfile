FROM httpd:latest

RUN apt-get update && \
    apt-get install -y apache2-utils && \
    rm -rf /var/lib/apt/lists/*

# Configuración de Basic Auth
COPY ./htpasswd /usr/local/apache2/conf/
COPY ./httpd.conf /usr/local/apache2/conf/
COPY ./web/jurassicsystems.com/static /usr/local/apache2/htdocs/

# Configuración de HTTPS
RUN openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/C=ES/ST=SEV/L=SEC/O=example/CN=localhost" \
    -keyout /usr/local/apache2/conf/server.key \
    -out /usr/local/apache2/conf/server.crt


EXPOSE 8443