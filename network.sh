#!/bin/bash

#login
#az login
#echo "Enter subscription id:" && read SUBSCRIPTION
#az account set --subscription $SUBSCRIPTION

RESOURCEGROUP=k8s-the-hard-way
VNET=k8s-the-hard-way
LOCATION=eastus
MASTER_DNS_PREFIX=k8sthehardway

echo "creating resource group"
az group create -n $RESOURCEGROUP --location $LOCATION
echo "creating vnet"
az network vnet create -n $VNET -g $RESOURCEGROUP --location $LOCATION --address-prefixes 10.240.0.0/24

echo "creating security group"
az network nsg create -n kubernetes -g $RESOURCEGROUP
echo "creating security group rule"
az network nsg rule create -n kubernetes-incoming -g $RESOURCEGROUP --nsg-name kubernetes \
--priority=101 \
--protocol='*' \
--direction='Inbound' \
--access='Allow' \
--destination-address-prefixes='*' \
--destination-port-ranges='*' \
--source-address-prefixes='*' \
--source-port-ranges='*'

echo "creating vnet subnet"
az network vnet subnet create -n kubernetes --address-prefix 10.240.0.0/24 -g $RESOURCEGROUP \
--vnet-name $VNET \
--network-security-group kubernetes

echo "creating public IP"
az network public-ip create -g $RESOURCEGROUP -n kubernetes-master \
--allocation-method='Static' \
--dns-name=$MASTER_DNS_PREFIX


