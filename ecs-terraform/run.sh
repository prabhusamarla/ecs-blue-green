#!/bin/bash

DEPLOY=$DEPLOY
case $DEPLOY in
CREATE)
 terraform init -input=false
 [ $? -eq 0 ] && terraform apply -auto-approve
 ;;
DESTROY)
terraform destroy -auto-approve
;;
esac
