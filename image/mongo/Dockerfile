FROM mongo:4.4.19

# Copiamos el archivo de configuración a la imagen
ADD mongo-config.yaml /etc/mongo/mongo-config.yaml
ADD mongodb.pem /etc/ssl/mongodb.pem

# Instalamos openssl
RUN apt-get update && apt-get install -y openssl

# Ejecutamos MongoDB con la configuración personalizada
CMD ["mongod", "--config", "/etc/mongo/mongo-config.yaml"]
