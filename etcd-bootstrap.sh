#!/bin/bash

wget -q --show-progress --https-only --timestamping \
  "https://github.com/coreos/etcd/releases/download/v3.3.5/etcd-v3.3.5-linux-amd64.tar.gz"

sudo tar -xzf etcd-v3.3.5-linux-amd64.tar.gz
sudo mv etcd-v3.3.5-linux-amd64/etcd* /usr/local/bin/
sudo rm etcd-v3.3.5-linux-amd64.tar.gz

sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp ~/ca.pem ~/kubernetes-key.pem ~/kubernetes.pem /etc/etcd/
sudo cp ~/etcd.service /etc/systemd/system/etcd.service

echo "starting etcd..."
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

echo "waiting to start..."
sleep 3s
#can also check the journal to make sure all is healthy
journalctl -u etcd.service -f