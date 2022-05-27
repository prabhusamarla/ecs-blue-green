#!/bin/bash

export USERID=$(id -u)
export PATH="$PATH:/usr/local/bin"
export GROUPID=$(id -g)
cd $(dirname $0)
docker-compose -f compose.yaml \
   run --rm -w "$WORKSPACE" -e DEPLOY=$DEPLOY \
   --name terraform-${BUILD_NUMBER} --entrypoint "run.sh" terraform
