# Description: This file contains all the variables used in the terraform code####################
variable "AWS_REGION" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment variable abbreviation"
  type        = string
  default     = "prod"

  validation { 
    condition     = contains(["staging", "prod"], var.env) #
    error_message = "Invalid argument \"env\", please choose one of: (\"staging\",\"prod\")."
  }
}

### VPC variables
variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks. Consider setting to false for HA in production env."
}


### EKS variables
variable "eks_default_instance_type" {
  type        = string
  default     = "t2.medium" # t2.medium is the default instance type for EKS
  description = "Default instance type for EKS cluster"
}

############################################################################################################
