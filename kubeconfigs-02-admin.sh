#!/bin/bash

CLUSTER=k8s-the-hard-way

  kubectl config set-cluster $CLUSTER \
    --certificate-authority=./_output/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=./_output/admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=./_output/admin.pem \
    --client-key=./_output/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=./_output/admin.kubeconfig

  kubectl config set-context default \
    --cluster=$CLUSTER \
    --user=admin \
    --kubeconfig=./_output/admin.kubeconfig

  kubectl config use-context default --kubeconfig=./_output/admin.kubeconfig
  
