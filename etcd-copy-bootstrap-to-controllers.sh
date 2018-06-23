#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way
for instance in controller-0 controller-1 controller-2; do
	EXTERNAL_IP=$(az vm list -g $RESOURCEGROUP --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
	scp -o "StrictHostKeyChecking no" etcd-bootstrap.sh azureuser@$EXTERNAL_IP:~/
done

