#!/bin/bash

mkdir ./_output
#Create SSH key
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ./_output/id_rsa
