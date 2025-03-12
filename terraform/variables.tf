variable "region" {
  default = region
  type    = string
}
variable "ecs_cluster_name" {
  default = "nnote-us-east-1-cluster"
  type    = string
}

variable "ecr_repository_name" {
  default = "nnote/app"
  type    = string
}

variable "ecs_task_definition_name" {
  default = "nnote-task-definition"
  type    = string
}

variable "container_name" {
  default = "nnote-container"
  type    = string
}

variable "cpu" {
  default = 1
  type    = number
}

variable "memory" {
  default = 3
  type    = number
}

variable "dockerPort" {
  default = 5000
  type    = number
}

variable "ecs_role_name" {
  default = "nhat-flasknote-ecs-role"
  type    = string
}

variable "ecsTaskExecutionRole" {
  default = "arn:aws:iam::566027688242:role/ecsTaskExecutionRole"
  type    = string
}

variable "ecs_service_name" {
  default = "nhat-flasknote-service"
  type    = string
}
