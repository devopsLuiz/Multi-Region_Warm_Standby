data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/network/terraform.tfstate"
    region = "us-east-1"
  }
}