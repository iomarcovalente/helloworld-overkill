resource "aws_ecs_cluster" "main" {
  name = join("", [var.stack_name,"-cluster"])
  tags = {
    Name = join("", [var.stack_name,"-cluster"])
  }
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = join("", [var.stack_name,"-task"])
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.iam_ecs_task_execution_role_arn
  container_definitions = jsonencode([{
    name        = var.stack_name
    image       = join("", [var.ecr_repo_url, ":latest"])
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
}

resource "aws_ecs_service" "main" {
 name                               = join("", [var.stack_name,"-service"])
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.main.arn
 desired_count                      = 2
 deployment_minimum_healthy_percent = 100
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"

 network_configuration {
   security_groups  = var.ecs_service_security_groups
   subnets          = var.private_subnets.*.id
   assign_public_ip = false
 }

 load_balancer {
   target_group_arn = var.aws_alb_target_group_arn
   container_name   = var.stack_name
   container_port   = var.container_port
 }

 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}
