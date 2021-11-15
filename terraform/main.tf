module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "vpc" {
  source = "./modules/vpc"
  stack_name                      = var.stack_name
}

module "ecs" {
  source = "./modules/ecs"
  stack_name                      = var.stack_name
  ecr_repo_url                    = module.ecr.ecr_repo_url
  private_subnets                 = module.vpc.subnets.private
  aws_alb_target_group_arn        = module.vpc.aws_alb_target_group_arn
  ecs_service_security_groups     = [module.vpc.security_group_ecs_tasks_id]
  iam_ecs_task_execution_role_arn = module.iam.iam_roles.ecs_task_execution_role_arn
}
