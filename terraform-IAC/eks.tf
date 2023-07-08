###########################Create EKS Cluster############################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.8.0"

  cluster_name    = local.name
  cluster_version = "1.25"

  vpc_id = module.vpc.vpc_id

  # EKS deployed in public and private subnet
  subnet_ids                     = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  cluster_endpoint_public_access = true


  tags = merge(local.default_tags, {
    CreatedBy = "capstone-10"
    Created   = "2023-06-20"
  })

  enable_irsa = true

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "Cluster API to K8S services running on nodes"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_cluster_api_ephemeral_ports_tcp = {
      description                   = "Cluster API to K8S services running on nodes"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_group_defaults = {
    use_name_prefix = true

    subnet_ids = module.vpc.private_subnets

    ami_type       = "AL2_x86_64"
    instance_types = [var.eks_default_instance_type]

    enable_monitoring = true

    key_name = module.key_pair.key_pair_name

    tags = {
      "k8s.io/cluster-autoscaler/enabled"       = "true"
      "k8s.io/cluster-autoscaler/${local.name}" = "owned"
    }

  }
  eks_managed_node_groups = {
    # Default worker group
    default_worker_group = {
      name         = "EKS_default_group"
      desired_size = 3
      max_size     = 4
      min_size     = 1
      disk_size    = 50
    }
  }
}

# cluster_addons = {
#     ebs_csi_driver = {
#       resolve_conflicts = "OVERWRITE"
#     }
#   }


module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name_prefix    = local.name
  create_private_key = true

  tags = merge(local.default_tags, {
    CreatedBy = "capstone-10"
    Created   = "2023-06-20"
  })
}
###########################Create EKS Cluster############################################
