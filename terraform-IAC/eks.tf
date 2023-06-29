
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.24"
  cluster_endpoint_public_access = true
  # cluster_auth_token = data.aws_eks_cluster_auth.cluster_auth.token
  # EKS Cluster Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # VPC

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  # Node Group(s)

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "t3a.medium"]
    disk_size      = 50
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 4
      desired_size = 2

      instance_types = ["t2.medium", "t3.medium", "t3a.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }


  # aws-auth configmap
  # manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "777777777777",
    "888888888888",
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

    node_security_group_additional_rules = {
      ingress_allow_access_from_control_plane = {
        type                          = "ingress"
        protocol                      = "tcp"
        from_port                     = 9443
        to_port                       = 9443
        source_cluster_security_group = true
        description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
      }
    }

}


# exec {
#   api_version = "client.authentication.k8s.io/v1beta1"
#   args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
#   command     = "aws"
# }




