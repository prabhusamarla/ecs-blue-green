# autoscaling.tf | Auto Scaling Group

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.aws-ecs-cluster.name}/${aws_ecs_service.default.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  #role_arn = aws_iam_instance_profile.ecs.name
  role_arn = aws_iam_role.ecs-autoscale-role.arn
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${var.env}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 50
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${var.env}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 50
  }
}