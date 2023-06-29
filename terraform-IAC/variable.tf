variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "eks-cluster-sg"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "my-eks-cluster"
}



# Define the associations variable
variable "associations" {
  type = map(object({
    action = string
  }))

  default = {
    "alb-listener" = {
      action = "ALLOW"
    }
  }
}



