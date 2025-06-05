#!/bin/bash

# Load environment variables from .env
set -o allexport
source .env
set +o allexport

# Run ECS task on Fargate
aws ecs run-task \
  --cluster "$CLUSTER_NAME" \
  --launch-type FARGATE \
  --task-definition "$TASK_NAME" \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_ID],securityGroups=[$SECURITY_GROUP_ID],assignPublicIp=ENABLED}" \
  --profile "$AWS_PROFILE"
