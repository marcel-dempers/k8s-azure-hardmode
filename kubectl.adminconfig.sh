#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way
KUBERNETES_PUBLIC_ADDRESS=$(az network public-ip show -n kubernetes-master -g $RESOURCEGROUP | jq .ipAddress | sed 's/\"//g')
CLUSTER=k8s-the-hard-way

  kubectl config set-cluster $CLUSTER \
    --certificate-authority=./_output/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=./_output/config

  kubectl config set-credentials admin \
    --client-certificate=./_output/admin.pem \
    --client-key=./_output/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=./_output/config

  kubectl config set-context default \
    --cluster=$CLUSTER \
    --user=admin \
    --kubeconfig=./_output/config

  kubectl config use-context default --kubeconfig=./_output/config

  kubectl get nodes --kubeconfig ./_output/config