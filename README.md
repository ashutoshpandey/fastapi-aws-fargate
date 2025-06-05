## Common Steps

1. Add following permission to IAM user

```bash
AmazonECS_FullAccess
AmazonEC2ContainerRegistryFullAccess 
```


2. Create ECR repository

```bash
aws ecr create-repository --repository-name fastapi-fargate --profile=aws_clayartists
```


3. Login Docker to ECR

```bash
aws ecr get-login-password --profile <aws_profile_name> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```

Replace `<aws_profile_name>` with aws profile configured on your system. If default, remove `--profile aws_profile_name`. 

Replace `<aws_account_id>` with your aws account id.

Change `<region>` to your ecr region like `us-east-2`.


4. Build and test docker image

```bash
docker build -t fastapi-fargate:<tagname> .
docker run -p 8000:8000 fastapi-fargate
```

Check with: `http://localhost:8000`


5. Create docker tag and push

```bash
docker tag fastapi-fargate:<tagname> <aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-fargate:<tagname>

docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-fargate:<tagname>
```

Replace <tagname> with a tag like v1


## AWS Fargate

1. Create the ECS cluster

```bash
aws ecs create-cluster --profile <aws_profile_name> --cluster-name fastapi-fargate-cluster
```


2. To register the task for Fargate launch type

First make sure you set the correct ECR URI by replacing following in `register-task.sh`:

```bash
export IMAGE_URL=<aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-fargate:<tagname>
```

Now,

```bash
chmod +x register-task.sh

./register-task.sh
```


## AWS App Runner

1. Go to AWS Console → App Runner
2. Click "Create service"
3. Choose source: Container registry
4. Source: Select Amazon ECR
5. Image: Choose your pushed image (e.g., fastapi-fargate:latest)
6. Port: Set to 8000 (FastAPI default)
7. Deployment trigger: Manual (unless you want auto-deploy on push)
8. Service name: e.g., fastapi-translate-app
9. CPU & Memory: Start with 0.25 vCPU and 512 MB (you can auto-scale later)
10. IAM Role: Choose existing or let AWS create one
11. Click "Create & Deploy"