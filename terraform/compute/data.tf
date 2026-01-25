data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/security/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "ecs_ue1" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}


data "aws_ami" "ecs_ue2" {
  provider    = aws.us_east_2
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}