locals {
  default_tags = {
    Terraform = "true"
    Env       = var.env
  }

  name = "Altschool-staging"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  create_workloads = true

}