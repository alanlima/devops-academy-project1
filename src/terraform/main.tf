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
  lb_subnets    = module.vpc.public_subnets[*].id
  https_enabled = var.https_enabled
}

module "container_registry" {
  source = "./modules/container_registry"
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


# module "EFS_MODULE" {
#   source = "MODULE_PATH"
# }

# module "ECS_CLUSTER_MODULE" {
#   source = "MODULE_PATH"
# }

# module "ECS_SERVICE_MODULE" {
#   source = "MODULE_PATH"
# }
