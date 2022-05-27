#!/bin/bash

export USERID=$(id -u)
export PATH="$PATH:/usr/local/bin"
export GROUPID=$(id -g)
cd $(dirname $0)

if [[ $DEPLOY == "CREATE" ]];then
    docker-compose -f compose.yaml \
    run --rm -w "$WORKSPACE" \
    --name terraform-${BUILD_NUMBER} terraform -chdir=ecs-terraform/ init -input=false
     docker-compose -f compose.yaml \
    run --rm -w "$WORKSPACE" \
    --name terraform-${BUILD_NUMBER} terraform -chdir=ecs-terraform/ apply -auto-approve
 else
    docker-compose -f compose.yaml \
    run --rm -w "$WORKSPACE" \
    --name terraform-${BUILD_NUMBER}  terraform -chdir=ecs-terraform/ destroy -auto-approve
 fi 
