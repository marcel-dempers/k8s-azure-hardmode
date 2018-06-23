#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way

for instance in controller-0 controller-1 controller-2; do
        EXTERNAL_IP=$(az vm list -g $RESOURCEGROUP --query="[?name=='${instance}']" -o json --show-details | jq .[0].publicIps | sed 's/\"//g')
        scp -o "StrictHostKeyChecking no" ./_output/admin.kubeconfig ./_output/kube-controller-manager.kubeconfig ./_output/kube-scheduler.kubeconfig azureuser@$EXTERNAL_IP:~/
done

