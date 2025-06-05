#!/bin/bash

# Define your image URL (replace with your real tag if needed)
export IMAGE_URL=<aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-fargate:<tagname>

# Generate the final JSON by replacing ${IMAGE_URL}
envsubst < task-def.json.template > task-def.json

# Register task with ECS
aws ecs register-task-definition \
  --cli-input-json file://task-def.json \
  --profile aws_clayartists
