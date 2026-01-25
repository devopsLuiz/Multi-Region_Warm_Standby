data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/compute/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_ec2_managed_prefix_list" "cloudfront" {
  filter {
    name   = "prefix-list-name"
    values = ["com.amazonaws.global.cloudfront.origin-facing"]
  }
}