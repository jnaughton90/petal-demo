locals {
  appname = "petal-demo-api"
}

resource "aws_ecs_cluster" "demo-cluster" {
  name = "petal-demo-api-cluster"

}

resource "aws_security_group" "ecs_security_group" {
  name = "ecshost-sg"
  description = "Security group ecs host"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family = local.appname
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn = data.aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = local.appname
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${local.appname}:${var.image_tag}"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "petal_api_service" {
  name            = "${local.appname}-service"
  launch_type = "FARGATE"
  cluster         = aws_ecs_cluster.demo-cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 1
  force_new_deployment = true
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  network_configuration {
    subnets = data.aws_subnets.all.ids
    security_groups = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = local.appname
    container_port   = 8080
  }
}