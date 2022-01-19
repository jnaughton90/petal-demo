data "aws_subnets" "all" {}

data "aws_vpc" "default" {}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"
}