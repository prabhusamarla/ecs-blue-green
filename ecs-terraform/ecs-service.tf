resource "aws_ecs_service" "default" {
  cluster = aws_ecs_cluster.aws-ecs-cluster.id
  # depends_on              = [aws_iam_role_policy_attachment.ecs]
  desired_count           = 1
  enable_ecs_managed_tags = true
  force_new_deployment    = true
  iam_role                = aws_iam_role.ecsServiceRole.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "blue"
    container_port   = 80
  }

  name            = "blue-app"
  task_definition = aws_ecs_task_definition.task_definition.arn
}


resource "aws_ecs_service" "green" {
  cluster = aws_ecs_cluster.aws-ecs-green.id
  # depends_on              = [aws_iam_role_policy_attachment.ecs]
  desired_count           = 1
  enable_ecs_managed_tags = true
  force_new_deployment    = true
  iam_role                = aws_iam_role.ecsServiceRole.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = "green"
    container_port   = 80
  }

  name            = "green-app"
  task_definition = aws_ecs_task_definition.task_definition_green.arn
}