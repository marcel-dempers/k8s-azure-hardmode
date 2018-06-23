#!/bin/bash

RESOURCEGROUP=k8s-the-hard-way
echo "running command:$1"

for i in 0 1 2; do
	az vm $1 -n controller-${i} -g $RESOURCEGROUP --no-wait
	az vm $1 -n worker-${i} -g $RESOURCEGROUP --no-wait
done
