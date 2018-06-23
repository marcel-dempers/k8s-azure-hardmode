#!/bin/bash

sudo mkdir -p /etc/kubernetes/config

#get k8s bins
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-scheduler" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubectl"

#install the bins
chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/

sudo mkdir -p /var/lib/kubernetes/

#install certs and keys
sudo mv ~/ca.pem ~/ca-key.pem ~/kubernetes-key.pem ~/kubernetes.pem \
~/service-account-key.pem ~/service-account.pem \
~/encryption-config.yaml /var/lib/kubernetes/

#kube-controller-manager config
sudo mv kube-controller-manager.kubeconfig /var/lib/kubernetes/
#kube-sheduler config
sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/

cat <<EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: componentconfig/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

#copy out the api server systemd file
sudo cp ~/kube-apiserver.service /etc/systemd/system/kube-apiserver.service
sudo cp ~/kube-controller-manager.service /etc/systemd/system/kube-controller-manager.service
sudo cp ~/kube-scheduler.service /etc/systemd/system/kube-scheduler.service

#start the api, controller and scheduler services
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler