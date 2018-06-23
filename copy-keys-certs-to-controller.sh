#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way

for instance in controller-0 controller-1 controller-2; do
	EXTERNAL_IP=$(az vm list -g $RESOURCEGROUP --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
	scp -o "StrictHostKeyChecking no" ./_output/ca.pem ./_output/ca-key.pem ./_output/kubernetes-key.pem ./_output/kubernetes.pem \
	./_output/service-account-key.pem ./_output/service-account.pem azureuser@$EXTERNAL_IP:~/
done
