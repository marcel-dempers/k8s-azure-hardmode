#!/bin/bash

for instance in worker-0 worker-1 worker-2; do
	EXTERNAL_IP=$(az vm list -g k8s-the-hard-way --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
	scp -o "StrictHostKeyChecking no" ./_output/ca.pem ./_output/${instance}-key.pem ./_output/${instance}.pem azureuser@$EXTERNAL_IP:~/
done
