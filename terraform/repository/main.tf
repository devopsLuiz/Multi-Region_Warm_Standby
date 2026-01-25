terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "remote-tfstate-lock"
    key            = "state/repository/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "remote-tfstate-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}