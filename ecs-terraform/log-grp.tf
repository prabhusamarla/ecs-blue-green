resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.env}-logs"

  tags = {
    Application = var.env
  }
}