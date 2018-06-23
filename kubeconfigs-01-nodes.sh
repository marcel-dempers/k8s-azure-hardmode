#!/bin/bash

CLUSTERNAME=k8s-the-hard-way
RESOURCEGROUP=k8s-the-hard-way

KUBERNETES_PUBLIC_ADDRESS=$(az network public-ip show -n kubernetes-master -g $RESOURCEGROUP | jq .ipAddress | sed 's/\"//g')

echo "generating kubeconfigs-nodes: public ip : $KUBERNETES_PUBLIC_ADDRESS"

for instance in worker-0 worker-1 worker-2; do
  kubectl config set-cluster $CLUSTERNAME \
    --certificate-authority=./_output/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=./_output/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=./_output/${instance}.pem \
    --client-key=./_output/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=./_output/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=$CLUSTERNAME \
    --user=system:node:${instance} \
    --kubeconfig=./_output/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=./_output/${instance}.kubeconfig
  #mv ${instance}.kubeconfig ./output/${instance}.kubeconfig
done

