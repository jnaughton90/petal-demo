# petal-demo

## Prerequisites

* Docker
* Terraform
* AWS CLI v2 Configured

## Build Application

The applicaton can be built running the provided build.sh script. This script will build the docker image and push it to a ECR Repository and tag it with the git revision.

## Deployment Process

### First Time Deployment

Running the deployment can be done by running deploy.sh

This will create all the necessary application components, the only prerequisite is that the S3 Bucket storing the statefile should already be create

The following resources will be created:
* ECS Cluster - Will provision the ECS Cluster in the AWS account
* ECS Task Definition - This defines the container definition and the Fargate Configuration for the Task
* ECS Service - The ECS Service that will provision tasks and add the tasks to the Target Group
* ECS Security Group - A security group to attach to the ECS service allowing only inbound traffic from the Application Load Balancer
* Application Load Balancer - A public facing application load balacer for fronting the application
* Target Group - The Target Group for the provisioned ECS Tasks
* ALB Listener - A HTTP Listener to forward requests to the Target Group
* ALB Security Group - A security group allowing inbound traffic on port 80 to the application load balancer

### Pushing Changes

In order to push new application changes, you must first commit your code. This will create a new git revision that will be used to tag the new application image. Then run the ./deploy.sh script to execute the deployment.

This will update the task definition resource with a new revision with the new container image and update the ECS Service. ECS Service will deploy the new task definition as a rolling update (Successful deploy of the new task before draining the existing task)