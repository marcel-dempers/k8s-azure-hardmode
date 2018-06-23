#!/bin/bash

CLUSTER=k8s-the-hard-way

  kubectl config set-cluster $CLUSTER \
    --certificate-authority=./_output/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=./_output/kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=./_output/kube-scheduler.pem \
    --client-key=./_output/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=./_output/kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=$CLUSTER \
    --user=system:kube-scheduler \
    --kubeconfig=./_output/kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=./_output/kube-scheduler.kubeconfig
