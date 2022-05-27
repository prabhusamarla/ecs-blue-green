# iam_instance_profile.ecs.tf

resource "aws_iam_instance_profile" "ecs" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecsTaskExecutionRole.name
}