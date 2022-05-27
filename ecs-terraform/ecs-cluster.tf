resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.env}-cluster"
  tags = {
    Name = "${var.env}-ecs"
  }
}

resource "aws_ecs_cluster" "aws-ecs-green" {
  name = "Green-cluster"
  tags = {
    Name = "green-Cluster"
  }
}