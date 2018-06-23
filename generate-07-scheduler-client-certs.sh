#!/bin/bash

cat > ./_output/kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-scheduler",
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
  -profile=kubernetes \
  ./_output/kube-scheduler-csr.json | cfssljson -bare ./_output/kube-scheduler

