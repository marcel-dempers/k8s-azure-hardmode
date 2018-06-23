#!/bin/bash

kubectl create -f kube-dns.yaml

echo "waiting for pods to start"
sleep 10s

kubectl get pods -l k8s-app=kube-dns -n kube-system

echo "verifying deployment"

kubectl run busybox --image=busybox --command -- sleep 3600

sleep 10s

kubectl get pods -l run=busybox

POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

kubectl exec -ti $POD_NAME -- nslookup kubernetes
