#!/bin/bash

for instance in worker-0 worker-1 worker-2; do
cat > ./_output/${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

EXTERNAL_IP=$(az vm list -g k8s-the-hard-way --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
INTERNAL_IP=$(az vm list -g k8s-the-hard-way --query="[?name=='${instance}']" -o json --show-details | jq .[0].privateIps | sed 's/\"//g')

echo "generating kubelet auth cert for worker public ip $EXTERNAL_IP and private ip: $INTERNAL_IP"
cfssl gencert \
  -ca=./_output/ca.pem \
  -ca-key=./_output/ca-key.pem \
  -config=./_output/ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ./_output/${instance}-csr.json | cfssljson -bare ./_output/${instance}
done
