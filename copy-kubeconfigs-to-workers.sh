#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way

for instance in worker-0 worker-1 worker-2; do
	EXTERNAL_IP=$(az vm list -g $RESOURCEGROUP --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
	scp -o "StrictHostKeyChecking no" ./_output/${instance}.kubeconfig ./_output/kube-proxy.kubeconfig azureuser@$EXTERNAL_IP:~/
done

