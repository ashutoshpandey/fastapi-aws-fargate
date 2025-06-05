## Steps

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


6. Create the ECS cluster

```bash
aws ecs create-cluster --profile aws_profile_name --cluster-name fastapi-fargate-cluster
```