module "ecr" {
  source = "./modules/ecr"
}

module "vpc" {
  source = "./modules/vpc"
}

output "subnets" {
  value = module.vpc.subnets
}
