# Create ECS Cluster
resource "aws_ecs_cluster" "web" {
  name = var.ecs_cluster_name
}

# Create ECR Repo
resource "aws_ecr_repository" "web" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true # allow Github Action to decommision this repo when it's not empty

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
  execution_role_arn       = var.ecsTaskExecutionRole
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
    subnets          = [aws_subnet.s1.name, aws_subnet.s2.name]
    security_groups  = [aws_security_group.nnote_vpc_sg.name]
    assign_public_ip = true
  }

  depends_on = [aws_vpc.nnote]
}
