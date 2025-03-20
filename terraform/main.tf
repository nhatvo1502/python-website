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
    subnets          = [aws_subnet.s1.id, aws_subnet.s2.id]
    security_groups  = [aws_security_group.nnote_vpc_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_vpc.nnote]
}

# Create RDS DB

# resource "aws_db_instance" "nnotedb" {
#   db_name                = var.db_name
#   allocated_storage      = 20
#   engine                 = "mysql"
#   engine_version         = "8.0"
#   instance_class         = var.db_instance_class
#   username               = var.db_username
#   password               = var.db_password
#   vpc_security_group_ids = [aws_security_group.nnote_vpc_sg.id]
#   db_subnet_group_name   = aws_db_subnet_group.nnotedb.name
#   skip_final_snapshot    = true
#   publicly_accessible    = true
# }

# resource "aws_db_subnet_group" "nnotedb" {
#   name       = var.subnet_g_name
#   subnet_ids = [aws_subnet.s1.id, aws_subnet.s2.id]
# }