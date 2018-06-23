#!/bin/bash

#login
#az login
#echo "Enter subscription id:" && read SUBSCRIPTION
#az account set --subscription $SUBSCRIPTION

RESOURCEGROUP=k8s-the-hard-way
VNET=k8s-the-hard-way
LOCATION=eastus
MASTER_DNS_PREFIX=k8sthehardway

az vm availability-set create -n kubernetes -g $RESOURCEGROUP --platform-fault-domain-count 2 --platform-update-domain-count 2

for i in 0 1 2; do	
az vm create -n controller-${i} \
	-g $RESOURCEGROUP \
	--availability-set kubernetes \
	--image ubuntults \
	--private-ip-address 10.240.0.1${i} \
	--size Standard_F4s_v2 \
	--vnet-name $VNET \
	--subnet kubernetes \
	--ssh-key-value ./_output/id_rsa.pub \
	--admin-username azureuser \
	--no-wait
done

for i in 0 1 2; do
        az vm create -n worker-${i} \
        -g $RESOURCEGROUP \
        --image ubuntults \
        --private-ip-address 10.240.0.2${i} \
        --size Standard_F8s_v2 \
        --vnet-name $VNET \
        --subnet kubernetes \
        --ssh-key-value ./_output/id_rsa.pub \
        --admin-username azureuser \
	--no-wait
done  

az vm list -g $RESOURCEGROUP -o table --show-details
