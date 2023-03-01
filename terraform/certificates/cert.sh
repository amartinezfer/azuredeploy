openssl genrsa -out key.pem 2048

openssl req -new -x509 -days 365 -key key.pem -out vmcert.pem -subj "/CN=vm.unir.io/O=unit/L=sevilla/C=ES"

openssl req -new -x509 -days 365 -key key.pem -out kubecert.pem -subj "/CN=kube.unir.io/O=unit/L=sevilla/C=ES"


