#!/bin/bash
shopt -s xpg_echo
REGION=$AWS_REGION
REGISTRY="$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.${REGION}.amazonaws.com"
REPO=$ECR_REPO
TAG=$TAG
ECR_IMAGE="$REGISTRY/$REPO:$TAG"
ECS_CLUSTER="$ECS_CLUSTER"
SERVICE_NAME="$ECS_SERVICE"
TASK_FAMILY=$(aws ecs describe-services --service $SERVICE_NAME --cluster $ECS_CLUSTER|grep taskDefinition|sed '1d'|awk -F'/' '{print $NF}'|sed 's|:.*||g')
AWS_DEFAULT_REGION="us-west-2"
TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "$TASK_FAMILY" --region "$AWS_DEFAULT_REGION")
NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION | jq --arg IMAGE "$ECR_IMAGE" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) | del(.registeredAt) |del(.registeredBy)')
NEW_TASK_INFO=$(aws ecs register-task-definition --family $TASK_FAMILY --region "$AWS_DEFAULT_REGION" --cli-input-json "$NEW_TASK_DEFINTIION")
NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')

echo "Deployment is being done for service ${SERVICE_NAME} in cluster $ECS_CLUSTER with image $ECR_IMAGE .. Please wait.."
aws ecs update-service --cluster ${ECS_CLUSTER} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${NEW_REVISION} > /dev/null 2>&1
aws autoscaling set-desired-capacity --auto-scaling-group-name ${ECS_CLUSTER/-*/}-ASG  --desired-capacity 2 --honor-cooldown
aws ecs wait services-stable \
    --cluster $ECS_CLUSTER \
    --services $SERVICE_NAME
[ $? -eq 0 ] && aws autoscaling set-desired-capacity --auto-scaling-group-name ${ECS_CLUSTER/-*/}-ASG --desired-capacity 1 --honor-cooldown
echo "Deployment completed ...!"
