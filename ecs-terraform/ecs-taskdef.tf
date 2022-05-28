resource "aws_ecs_task_definition" "task_definition" {
  family                   = "Blue"
  container_definitions    = data.template_file.task_definition_template.rendered
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  volume {
    name      = "nginx-data"
    host_path = "/data/nginx"
  }
}

resource "aws_ecs_task_definition" "task_definition_green" {
  family                   = "Green"
  container_definitions    = data.template_file.task_definition_green.rendered
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  volume {
    name      = "nginx-data"
    host_path = "/data/nginx"
  }
}
