openssl genrsa -out key.pem 2048

openssl req -new -key key.pem -out csr.pem -subj "/C=es/ST=svq/L=svq/O=test/OU=dev/CN=test"



openssl x509 -req -days 365 -in csr.pem -signkey key.pem -out cert.pem

cat cert.pem key.pem > mongodb.pem
