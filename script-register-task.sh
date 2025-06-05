#!/bin/bash

# Load environment variables from .env
set -o allexport
source .env
set +o allexport

# Replace variables in the task definition template
envsubst < "$TASK_DEF_TEMPLATE" > "$TASK_DEF"

# Register task with ECS using the profile from .env
aws ecs register-task-definition \
  --cli-input-json file://$TASK_DEF \
  --profile "$AWS_PROFILE"
