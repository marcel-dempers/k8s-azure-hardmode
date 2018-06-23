#!/bin/bash

#login
#az login
#echo "Enter subscription id:" && read SUBSCRIPTION
#az account set --subscription $SUBSCRIPTION

RESOURCEGROUP=k8s-the-hard-way

echo "creating a load balancer"
az network lb create -n kubernetes -g $RESOURCEGROUP
echo "creating an address pool"
az network lb address-pool create -n backend --lb-name kubernetes -g $RESOURCEGROUP
echo "creating a front end ip"
az network lb frontend-ip create -n frontend --lb-name kubernetes -g $RESOURCEGROUP --public-ip-address kubernetes-master
echo "creating a probe"
az network lb probe create -n healthcheck --lb-name kubernetes -g $RESOURCEGROUP --port 80 --protocol Http --path="/healthz"

echo "creating a healthcheck rule"
az network lb rule create -n healthcheck --lb-name kubernetes -g $RESOURCEGROUP \
--protocol Tcp \
--frontend-port 80 \
--backend-port 80 \
--frontend-ip-name frontend \
--backend-pool-name backend \
--probe-name healthcheck

echo "creating kube-api-server rule"
az network lb rule create -n api-server --lb-name kubernetes -g $RESOURCEGROUP \
--protocol Tcp \
--frontend-port 6443 \
--backend-port 6443 \
--frontend-ip-name frontend \
--backend-pool-name backend \
--probe-name healthcheck

echo "adding security group for health check"
az network nsg rule create -n kubernetes-healthcheck -g $RESOURCEGROUP --nsg-name kubernetes \
--priority=102 \
--protocol='*' \
--direction='Inbound' \
--access='Allow' \
--destination-address-prefixes='*' \
--destination-port-ranges='80' \
--source-address-prefixes='*' \
--source-port-ranges='*'

for instance in controller-0 controller-1 controller-2; do
  NIC=$(az vm show -g $RESOURCEGROUP -n ${instance} -o json | jq .networkProfile.networkInterfaces[0].id | sed 's/\"//g')
  NIC_NAME=$(az network nic show -g $RESOURCEGROUP --ids $NIC -o json | jq .name)

  # allow health check probe to VM nic
  NSG_ID=$(az network nic show -g $RESOURCEGROUP --ids $NIC -o json | jq .networkSecurityGroup.id | sed 's/\"//g')
  NSG=$(az network nsg show -g $RESOURCEGROUP --ids $NSG_ID -o json | jq .name | sed 's/\"//g')
  az network nsg rule create -n healthcheck --nsg-name $NSG \
  --priority 1010 \
  -g $RESOURCEGROUP \
  --access Allow \
  --direction Inbound \
  --protocol="*" \
  --destination-address-prefixes="*" \
  --destination-port-ranges="80" \
  --source-address-prefix="*" \
  --source-port-ranges="*"
  
  az network nsg rule create -n kube-api-server --nsg-name $NSG \
  --priority 1011 \
  -g $RESOURCEGROUP \
  --access Allow \
  --direction Inbound \
  --protocol="*" \
  --destination-address-prefixes="*" \
  --destination-port-ranges="6443" \
  --source-address-prefix="*" \
  --source-port-ranges="*"
  az network nic ip-config address-pool add -g $RESOURCEGROUP --nic-name $NIC_NAME --address-pool backend --lb-name kubernetes --ids $NIC --ip-config-name "ipconfig${instance}"
done
