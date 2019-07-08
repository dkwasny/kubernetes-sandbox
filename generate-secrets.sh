#!/bin/bash

# List of "clients" to generate certificats for.
# Machines have an IP address attached, users do not.
CLIENTS="
    kube-master/kube-master.kwas-cluster.local/10.100.0.10
    kube-node-1/kube-node-1.kwas-cluster.local/10.100.0.11
    kube-client/kube-client.kwas-cluster.local/10.100.0.20
    kube-admin/kube-admin
    kube-dashboard/system:serviceaccount:kube-system:kubernetes-dashboard
    kube-coredns/system:serviceaccount:kube-system:coredns
    kube-ingress-nginx/system:serviceaccount:ingress-nginx:nginx-ingress-serviceaccount
    ingress-wildcard/*.kube-ingress.local
";

DIR_NAME="$(dirname $0)";
CERT_DIR="$DIR_NAME/files/secrets";

TMP_CERT_EXTENSIONS_FILE="$(mktemp)";

# TODO: Encrypt your damn keys
# Add `-aes256` and `-passout pass:password` to genrsa commands
# Add `-passin pass:password` to req and x509 commands
# Maybe even use a real password or something...

##### TLS Key and Cert Generation

function generateClientCert() {
    local HOST_TUPLE="$1";
    local FILENAME="$(echo $HOST_TUPLE | cut -d/ -f1)";
    local HOSTNAME="$(echo $HOST_TUPLE | cut -d/ -f2)";
    local IP_ADDRESS="$(echo $HOST_TUPLE | cut -d/ -f3 -s)";

    echo "Generating private key for $HOSTNAME";
    CLIENT_KEY="$CERT_DIR/$FILENAME.key";
    openssl genrsa \
        -out "$CLIENT_KEY" \
        2048;

    echo "Generating CSR for $HOSTNAME";
    CLIENT_CSR="$CERT_DIR/$FILENAME-csr.pem";
    openssl req \
        -new \
        -key "$CLIENT_KEY" \
        -out "$CLIENT_CSR" \
        -subj "/C=US/ST=State/L=City/O=Kube Clients/OU=IT/CN=$HOSTNAME";

    if [ -n "$IP_ADDRESS" ]; then
        echo "subjectAltName=IP:$IP_ADDRESS,DNS:$HOSTNAME" > "$TMP_CERT_EXTENSIONS_FILE";
    else
        echo "" > "$TMP_CERT_EXTENSIONS_FILE";
    fi;

    echo "Generating certificate for $HOSTNAME";
    CLIENT_CERT="$CERT_DIR/$FILENAME.pem";
    openssl x509 \
        -req \
        -in "$CLIENT_CSR" \
        -CA "$CA_CERT" \
        -CAkey "$CA_KEY" \
        -out "$CLIENT_CERT" \
        -CAcreateserial \
        -extfile "$TMP_CERT_EXTENSIONS_FILE";
}

echo "Generating CA's private key";
CA_KEY="$CERT_DIR/ca.key";
openssl genrsa \
    -out "$CA_KEY" \
    2048;

echo "Generating CA's certificate";
CA_CERT="$CERT_DIR/ca.pem";
openssl req \
    -new \
    -x509 \
    -days 365 \
    -key "$CA_KEY" \
    -out "$CA_CERT" \
    -subj "/C=US/ST=State/L=City/O=Honest Dave's Certs/OU=IT/CN=honestdave.com";

for i in $CLIENTS; do
    generateClientCert "$i";
done;

##### Misc Key Generation

echo "Generating the service account private key";
SERVICE_ACCOUNT_PRIVATE_KEY="$CERT_DIR/service-account-private.key";
openssl genrsa \
    -out "$SERVICE_ACCOUNT_PRIVATE_KEY" \
    2048;

echo "Generating the service account public key";
SERVICE_ACCOUNT_PUBLIC_KEY="$CERT_DIR/service-account-public.key";
openssl rsa \
    -pubout \
    -in "$SERVICE_ACCOUNT_PRIVATE_KEY" \
    -out "$SERVICE_ACCOUNT_PUBLIC_KEY";

echo "Generated a miserable little pile of secrets!";
