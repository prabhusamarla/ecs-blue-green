resource "aws_autoscaling_group" "web" {
  name                      = "${var.env}-ASG"
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 20
  health_check_type         = "EC2"
  health_check_grace_period = 120
  default_cooldown          = 300
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = var.env == "Prod" ? aws_subnet.private_subnet.*.id : aws_subnet.public_subnet.*.id
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      on_demand_allocation_strategy            = "prioritized"
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 2
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.first.id
        version            = aws_launch_template.first.latest_version
      }
      override {
        instance_type = "t2.micro"
      }
      override {
        instance_type = "t2.nano"
      }
    }
  }
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Blue"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "green" {
  name                      = "Green-ASG"
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 20
  health_check_type         = "EC2"
  health_check_grace_period = 120
  default_cooldown          = 300
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = var.env == "Prod" ? aws_subnet.private_subnet.*.id : aws_subnet.public_subnet.*.id
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      on_demand_allocation_strategy            = "prioritized"
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 2
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.green.id
        version            = aws_launch_template.green.latest_version
      }
      override {
        instance_type = "t2.micro"
      }
      override {
        instance_type = "t2.nano"
      }
    }
  }
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Green"
    propagate_at_launch = true
  }
}