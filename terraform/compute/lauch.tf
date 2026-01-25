resource "aws_launch_template" "ecs_lt_us-east-1" {
  name_prefix   = "ecs-template-us-east-1"
  image_id      = data.aws_ami.ecs_ue1.id
  instance_type = "t3.medium"


  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.security_groups-us-east-1
  ]

  iam_instance_profile {
    name = data.terraform_remote_state.security.outputs.ecs_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs-us-east-1.sh")
}

#-------------------------- us-east-2 -------------------------------------

resource "aws_launch_template" "ecs_lt_us-east-2" {
  provider      = aws.us_east_2
  name_prefix   = "ecs-template-us-east-2"
  image_id      = data.aws_ami.ecs_ue2.id
  instance_type = "t3.medium"

  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.security_groups-us-east-2
  ]

  iam_instance_profile {
    name = data.terraform_remote_state.security.outputs.ecs_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs-us-east-2.sh")
}
