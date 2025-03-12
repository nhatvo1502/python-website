provider "aws" {
  region = "us-east-1"
}

# Create ECS Cluster
resource "aws_ecs_cluster" "web" {
  name = var.ecs_cluster_name
}

# Create ECR Repo
resource "aws_ecr_repository" "web" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create Task Definition
resource "aws_ecs_task_definition" "web" {
  family                   = var.ecs_task_definition_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn = var.ecsTaskExecutionRole 
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = aws_ecr_repository.web.repository_url
      essential = true
      portMapping = [
        {
          containerPort = var.dockerPort
          hostPort      = 80
        }
      ]
    }
  ])
}

# Create Service
resource "aws_ecs_service" "web" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.web.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-bc90b0b2", "subnet-3bc6a85d"]
    security_groups  = ["sg-97a12696"]
    assign_public_ip = true
  }
}
