#!/bin/bash

HOSTS="
    kube-master
    kube-node-1
    kube-client
";

DIR_NAME="$(dirname $0)";
CERT_DIR="$DIR_NAME/files/secrets";

# TODO: Encrypt your damn keys
# Add `-aes256` and `-passout pass:password` to genrsa commands
# Add `-passin pass:password` to req and x509 commands
# Maybe even use a real password or something...

##### TLS Key and Cert Generation

function generateClientCert() {
    local HOSTNAME="$1";

    CLIENT_KEY="$CERT_DIR/$HOSTNAME.key";
    openssl genrsa \
        -out "$CLIENT_KEY" \
        2048;

    CLIENT_CSR="$CERT_DIR/$HOSTNAME-csr.pem";
    openssl req \
        -new \
        -key "$CLIENT_KEY" \
        -out "$CLIENT_CSR" \
        -subj "/C=US/ST=State/L=City/O=Kube Clients/OU=IT/CN=$HOSTNAME";

    CLIENT_CERT="$CERT_DIR/$HOSTNAME.pem";
    openssl x509 \
        -req \
        -in "$CLIENT_CSR" \
        -CA "$CA_CERT" \
        -CAkey "$CA_KEY" \
        -out "$CLIENT_CERT" \
        -CAcreateserial;
}

CA_KEY="$CERT_DIR/ca.key";
openssl genrsa \
    -out "$CA_KEY" \
    2048;

CA_CERT="$CERT_DIR/ca.pem";
openssl req \
    -new \
    -x509 \
    -days 365 \
    -key "$CA_KEY" \
    -out "$CA_CERT" \
    -subj "/C=US/ST=State/L=City/O=Honest Dave's Certs/OU=IT/CN=honestdave.com";

for i in $HOSTS; do
    generateClientCert "$i";
done;

##### Misc Key Generation

SERVICE_ACCOUNT_PRIVATE_KEY="$CERT_DIR/service-account-private.key";
openssl genrsa \
    -out "$SERVICE_ACCOUNT_PRIVATE_KEY" \
    2048;

SERVICE_ACCOUNT_PUBLIC_KEY="$CERT_DIR/service-account-public.key";
openssl rsa \
    -pubout \
    -in "$SERVICE_ACCOUNT_PRIVATE_KEY" \
    -out "$SERVICE_ACCOUNT_PUBLIC_KEY";

echo "Generated a miserable little pile of secrets!";
