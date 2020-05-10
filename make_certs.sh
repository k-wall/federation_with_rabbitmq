#!/usr/bin/env bash

set -e

CA_CRT=ca.crt
CA_KEY=ca.key
CA_SUBJECT="/C=UK/O=MyCA"

SERVER_CRT=server.crt
SERVER_KEY=server.key
SERVER_SUBJECT="/CN=localhost"
SERVER_CSR=server.csr
SERVER_SUBJECT_ALT="subjectAltName=DNS:localhost,DNS:192.168.1.111"

CLIENT_CRT=client.crt
CLIENT_KEY=client.key
CLIENT_SUBJECT="/CN=guest"
CLIENT_CSR=client.csr

# Create CA
openssl req -new -days 11000 -x509 -batch -nodes \
            -out ${CA_CRT} \
            -keyout ${CA_KEY} \
            -subj ${CA_SUBJECT}

# Create server cert
openssl req -new -days 11000 -x509 -batch -nodes \
            -out ${SERVER_CRT} \
            -keyout ${SERVER_KEY} \
            -subj ${SERVER_SUBJECT}


openssl req -new -batch -nodes -key ${SERVER_KEY} -subj ${SERVER_SUBJECT} -out ${SERVER_CSR}

openssl x509 -req -extfile <(printf ${SERVER_SUBJECT_ALT}) -days 11000 -in ${SERVER_CSR} \
             -CA ${CA_CRT} \
             -CAkey ${CA_KEY} \
             -CAcreateserial -out ${SERVER_CRT}

# Create client cert
openssl req -new -days 11000 -x509 -batch -nodes \
            -out ${CLIENT_CRT} \
            -keyout ${CLIENT_KEY} \
            -subj ${CLIENT_SUBJECT}

openssl req -new -batch -nodes -key ${CLIENT_KEY} -subj ${CLIENT_SUBJECT} -out ${CLIENT_CSR}

openssl x509 -req -days 11000 -in ${CLIENT_CSR} \
             -CA ${CA_CRT} \
             -CAkey ${CA_KEY} \
             -CAcreateserial -out ${CLIENT_CRT}

chmod a+r ${CA_CRT} ${SERVER_CRT} ${SERVER_KEY}
