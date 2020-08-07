data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source             = "./modules/vpc"
  project            = var.project
  vpc_cidr           = var.vpc_cidr
  deploy_nat         = var.deploy_nat
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "load_balancer" {
  source        = "./modules/load_balancer"
  project       = var.project
  vpc_id        = module.vpc.vpc_id
  lb_subnets    = keys(module.vpc.public_subnets)
  https_enabled = var.https_enabled
}

module "container_registry" {
  source          = "./modules/container_registry"
  repository_name = "wordpress"
}

# module "rds" {
#   source = "./modules/rds"
# }

# module "rds-aurora-database" {
#   source  = "./modules/rds-aurora-database"
#   project = var.project
#   vpc = {
#     id         = module.vpc.vpc_id
#     cidr_block = var.vpc_cidr
#   }
#   private_subnets = module.vpc.private_subnets[*].id
# }

module "efs" {
  source          = "./modules/efs"
  project         = var.project
  vpc_cidr        = var.vpc_cidr
  vpc_id          = module.vpc.vpc_id
  private_subnets = keys(module.vpc.private_subnets)
  common_tags     = {}
  ecs_sg_id = ""
}

# module "ECS_CLUSTER_MODULE" {
#   source = "MODULE_PATH"
# }

# module "ECS_SERVICE_MODULE" {
#   source = "MODULE_PATH"
# }
