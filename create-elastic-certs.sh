#!/bin/bash
set -e
if [[ -z $CA_PASSWD ]] || [[ -z $CERT_PASSWD ]] ; then
  echo " Provide CA Password [CA_PASSWD] and Cert password [CERT_PASSWD] before hand"
  exit 1
fi

rm -f elastic-certificates.p12 elastic-certificate.pem elastic-stack-ca.p12 || true
#password=$$([ ! -z "$$ELASTIC_PASSWORD" ] && echo $$ELASTIC_PASSWORD || echo $$(docker run --rm $(ELASTICSEARCH_IMAGE) /bin/sh -c "< /dev/urandom tr -cd '[:alnum:]' | head -c20")) && \
docker run --name elastic-helm-charts-certs -i -w /app \
${ELASTICSEARCH_IMAGE:-docker.elastic.co/elasticsearch/elasticsearch:7.6.2} \
/bin/sh -c " \
elasticsearch-certutil ca --out /app/elastic-stack-ca.p12 --pass '$CA_PASSWD' && \
elasticsearch-certutil cert --name elasticsearch-master-cert --dns elasticsearch-master,elasticsearch-master-0.elasticsearch-master-headless,elasticsearch-master-1.elasticsearch-master-headless,elasticsearch-2.elasticsearch-master-headless --ca /app/elastic-stack-ca.p12 --pass '$CERT_PASSWD' --ca-pass '$CA_PASSWD' --out /app/elastic-certificates.p12" && \
mkdir certs && docker cp elastic-helm-charts-certs:/app/elastic-stack-ca.p12 certs/ && \
docker cp elastic-helm-charts-certs:/app/elastic-certificates.p12 efk/certs/ && \
docker rm -f elastic-helm-charts-certs
echo "elastic certificate created successfully and stored at location $pwd/certs. "
# Extract the CA certificate in PEM format for kibana to ssl verify elastic TLS
openssl pkcs12 -nodes -passin pass:"$CA_PASSWD" -in efk/certs/elastic-stack-ca.p12 -out efk/certs/elastic-ca.pem
echo "CA certificate(pem format) created successfully and stored at location $pwd/certs. "