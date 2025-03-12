output "ecr_uri" {
	value = aws_ecr_repository.web.repository_url
}

output "cluster_arn" {
	value = aws_ecs_cluster.web.arn
}

output "service_name" {
	value = aws_ecs_name.name
}

output "region" {
	value = var.region
}