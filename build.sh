#Login to ECR
aws ecr get-login-password --profile petaldemo | docker login --username AWS --password-stdin 928975195257.dkr.ecr.us-east-1.amazonaws.com

#Build application
docker build -t petal-demo-api ./app

#Tag image
docker tag petal-demo-api:latest 928975195257.dkr.ecr.us-east-1.amazonaws.com/petal-demo-api:$(git rev-parse --short HEAD)

#Push image to ECR
docker push 928975195257.dkr.ecr.us-east-1.amazonaws.com/petal-demo-api:$(git rev-parse --short HEAD)

#Output revision to file
echo "$(git rev-parse --short HEAD)" > revision.txt