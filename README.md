# efk-k8s
Elastic Fluentd and Kibana Stack on Kubernetes with X-Pack for AuthN and TLS

## Execution
1. `$export CA_PASSWD='$0meR@nd0mP@ss'; export CERT_PASSWD='$0meR@nd0mP@ss' && ./create-elastic-certs.sh`
2. `helm repo add elastic https://helm.elastic.co`
3. `helm repo add kiwigrid https://kiwigrid.github.io && helm repo update`
4. `git clone git@github.com:Sudharma/efk-k8s.git && cd efk-k8s`
5. `helm install efk --name efk --namespace efk`
 

## Note
1. All the helm charts are in beta mode. Please keep track on the changes.
2. Since EFK can be installed in various modes this repo has used most of the predefined configurations for elastic.

## References
 1. https://github.com/elastic/helm-charts/tree/master/elasticsearch/examples/security
 2. https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls.html#tls-transport
 3. https://www.elastic.co/guide/en/kibana/7.6/configuring-tls.html

