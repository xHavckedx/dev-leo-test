module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = "dev-cloud-apps"
  cluster_version = "1.24"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true # esto es mala práctica en producción.
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
        resolve_conflicts_on_create = "OVERWRITE"
    }

    vpc-cni = {
        resolve_conflicts_on_create = "OVERWRITE"
    }

    kube-proxy = {
        resolve_conflicts_on_create = "OVERWRITE"
    }

    # csi = { # no se puede usar con EKS 1.24
    #     resolve_conflicts_on_create = "OVERWRITE"
    # }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
        userarn = "arn:aws:iam::123456789012:user/terraform"
        username = "terraform"
        groups = ["system:masters"]
    }
  ]

  eks_managed_node_groups = {
    dev-cloud-apps-ng = {
        desired_capacity = 1
        min_capactiy = 1
        max_capactity = 4
        instance_types = ["t3.micro"]

        tags = {
            Terraform = true
            Environment = "dev"
        }
    }
  }
}

data "aws_eks_cluster" "cluster" { # consigue la información del cluster EKS.
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" { # consigue el token de acceso al cluster y lo utiliza para autenticar con el cluster.
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host =  data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
}