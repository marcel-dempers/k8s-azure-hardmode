#!/bin/bash

#login
#az login
#echo "Enter subscription id:" && read SUBSCRIPTION
#az account set --subscription $SUBSCRIPTION

RESOURCEGROUP=k8s-the-hard-way
ROUTETABLE=workers-routetable
VNET=k8s-the-hard-way

az network route-table create --name $ROUTETABLE -g $RESOURCEGROUP

for i in 0 1 2; do
  az network route-table route create --name kubernetes-route-10-200-${i}-0-24 \
    -g $RESOURCEGROUP \
    --route-table-name $ROUTETABLE \
    --next-hop-ip-address 10.240.0.2${i} \
    --address-prefix 10.200.${i}.0/24 \
    --next-hop-type VirtualAppliance
done

az network vnet subnet update --name kubernetes -g $RESOURCEGROUP --vnet-name $VNET --route-table $ROUTETABLE

az network route-table route list -g $RESOURCEGROUP --route-table-name $ROUTETABLE --output table
