#!/bin/bash

CLUSTER=k8s-the-hard-way
RESOURCEGROUP=k8s-the-hard-way
KUBERNETES_PUBLIC_ADDRESS=$(az network public-ip show -n kubernetes-master -g $RESOURCEGROUP | jq .ipAddress | sed 's/\"//g')

echo "creating kube-proxy config for public ip : $KUBERNETES_PUBLIC_ADDRESS"
  kubectl config set-cluster $CLUSTER \
    --certificate-authority=./_output/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=./_output/kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=./_output/kube-proxy.pem \
    --client-key=./_output/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=./_output/kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=$CLUSTER \
    --user=system:kube-proxy \
    --kubeconfig=./_output/kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=./_output/kube-proxy.kubeconfig

