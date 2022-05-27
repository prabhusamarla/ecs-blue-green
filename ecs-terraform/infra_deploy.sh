#!/bin/bash


function create() {
terraform init -input=false
[ $? -eq 0 ] && terraform apply -auto-approve
}

function destroy() {
terraform destroy -auto-approve
}

if [[ $DEPLOY == CREATE ]];then
   cmd=create
else
   cmd=destroy
fi

export USERID=$(id -u)
export PATH="$PATH:/usr/local/bin"
export GROUPID=$(id -g)
cd $(dirname $0)

docker-compose -f compose.yaml \
   run --rm -w "$WORKSPACE" \
   --name terraform-${BUILD_NUMBER} $cmd
