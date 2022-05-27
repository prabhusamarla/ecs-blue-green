terraform {
  backend "s3" {
    bucket = "s3-bucket-for-statefile-bkp"
    key = "ecs-canary-bluegreen.tf"
    region = "us-west-2"
    dynamodb_table = "for_state_lock"
    encrypt = true
  }
}