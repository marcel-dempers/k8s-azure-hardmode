#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way
KUBERNETES_PUBLIC_ADDRESS=$(az network public-ip show -n kubernetes-master -g $RESOURCEGROUP | jq .ipAddress | sed 's/\"//g')

echo "generating api client cert for API on public ip: $KUBERNETES_PUBLIC_ADDRESS"
cat > ./_output/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=./_output/ca.pem \
  -ca-key=./_output/ca-key.pem \
  -config=./_output/ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  ./_output/kubernetes-csr.json | cfssljson -bare ./_output/kubernetes

