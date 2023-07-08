# Description: Provider configuration for AWS and Kubernetes####################
provider "aws" {
  region = var.AWS_REGION

  # Use this is using custom credentials
  #   access_key = var.AWS_ACCESS_KEY_ID
  #   secret_key = var.AWS_SECRET_ACCESS_KEY
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}
############################################################################################################
