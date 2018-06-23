#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > ./_output/encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

for instance in controller-0 controller-1 controller-2; do
  EXTERNAL_IP=$(az vm list -g $RESOURCEGROUP --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
  scp -o "StrictHostKeyChecking no" ./_output/encryption-config.yaml azureuser@$EXTERNAL_IP:~/
done

