# Description: Outputs for the EKS cluster####################
output "region" {
  description = "AWS region"
  value       = var.AWS_REGION
}

# EKS outputs
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value     = module.eks.cluster_certificate_authority_data
  sensitive = true
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "aws_auth_configmap_yaml" {
  value = module.eks.aws_auth_configmap_yaml
}


# VPC outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "elasticache_subnets" {
  value = module.vpc.elasticache_subnets
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

############################################################################################################
