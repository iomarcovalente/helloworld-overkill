module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecs" {
  source = "./modules/ecs"
  ecr_repo_name = module.ecr.ecr_repo_arn
  iam_ecs_task_execution_role_arn = module.iam.iam_roles.ecs_task_execution_role_arn
}
