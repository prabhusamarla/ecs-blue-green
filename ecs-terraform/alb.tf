####################################################
# Target Group Creation
####################################################

resource "aws_lb_target_group" "blue" {
  name                 = "TargetGroup-Blue"
  deregistration_delay = 60
  port                 = 80
  # target_type = "instance"
  protocol = "HTTP"
  vpc_id   = aws_vpc.MyVpc.id
  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
    matcher  = "200-499"
  }
}

resource "aws_lb_target_group" "green" {
  name                 = "TargetGroup-Green"
  deregistration_delay = 60
  port                 = 80
  # target_type = "instance"
  protocol = "HTTP"
  vpc_id   = aws_vpc.MyVpc.id
  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
    matcher  = "200-499"
  }
}

####################################################
# Target Group Attachment with Instance
####################################################

/*
resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(aws_instance.ec2demo.*.id) == 3 ? 3 : 1
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(aws_instance.ec2demo.*.id, count.index)
}
*/
####################################################
# Application Load balancer
####################################################

resource "aws_lb" "lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id, ]
  subnets            = aws_subnet.public_subnet.*.id
}

####################################################
# Listner
####################################################
/*
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}
*/

####################################################
# Listener Rule
####################################################
/*
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.blue.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn

  }
  condition {
    path_pattern {
      values = ["/app/blue"]
    }
  }
}
*/

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"
  #priority          = 100
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = 100
      }
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = 0
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}