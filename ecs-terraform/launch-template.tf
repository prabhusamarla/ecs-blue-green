
locals {
  my_user_data = templatefile("format.tpl", {
    CLUSTER = "${var.env}-cluster"
  })
}

resource "aws_launch_template" "first" {
  name = "First"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdf"
    ebs {
      volume_size           = 3
      delete_on_termination = true
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdg"
    ebs {
      volume_size           = 5
      delete_on_termination = true
    }
  }
  ebs_optimized                        = false
  image_id                             = data.aws_ami.default.id
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "Terraform"
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test"
    }
  }
  user_data = base64encode(local.my_user_data)
}

resource "aws_launch_template" "green" {
  name = "green"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdf"
    ebs {
      volume_size           = 3
      delete_on_termination = true
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdg"
    ebs {
      volume_size           = 5
      delete_on_termination = true
    }
  }
  ebs_optimized                        = false
  image_id                             = data.aws_ami.default.id
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "Terraform"
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "green"
    }
  }
  user_data = filebase64("format.sh")
}