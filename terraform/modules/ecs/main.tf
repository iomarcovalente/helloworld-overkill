resource "aws_ecs_cluster" "main" {
  name = "helloworld-overkill"
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = "helloworld-overkill-task"
  cpu                      = 128
  memory                   = 128
  execution_role_arn       = var.iam_ecs_task_execution_role_arn
  # task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name        = "helloworld-overkill"
    image       = join("", [var.ecr_repo_name, "/helloworld-overkill:latest"])
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 8080
      hostPort      = 8080
    }]
  }])
}

resource "aws_ecs_service" "main" {
 name                               = "helloworld-overkill-service"
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.main.arn
 desired_count                      = 1
 deployment_minimum_healthy_percent = 100
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"

 network_configuration {
   security_groups  = var.ecs_service_security_groups
   subnets          = var.subnets.*.id
   assign_public_ip = false
 }

 load_balancer {
   target_group_arn = var.aws_alb_target_group_arn
   container_name   = "${var.name}-container-${var.environment}"
   container_port   = var.container_port
 }

 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}
