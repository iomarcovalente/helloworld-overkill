variable "stack_name" {}

variable "ecr_repo_url" {}

variable "iam_ecs_task_execution_role_arn" {}

variable "private_subnets" {}

variable "aws_alb_target_group_arn" {}

variable "ecs_service_security_groups" {}

variable "container_port" {
  default = 8080
}
