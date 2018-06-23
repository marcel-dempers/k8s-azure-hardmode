#!/bin/bash

CLUSTER=k8s-the-hard-way

  kubectl config set-cluster $CLUSTER \
    --certificate-authority=./_output/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=./_output/kube-controller-manager.kubeconfig
  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=./_output/kube-controller-manager.pem \
    --client-key=./_output/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=./_output/kube-controller-manager.kubeconfig
  kubectl config set-context default \
    --cluster=$CLUSTER \
    --user=system:kube-controller-manager \
    --kubeconfig=./_output/kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=./_output/kube-controller-manager.kubeconfig
