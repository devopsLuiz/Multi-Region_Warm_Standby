resource "aws_autoscaling_group" "ecs_asg-us-east-1" {
 vpc_zone_identifier = [data.terraform_remote_state.network.outputs.subnet1-us-east-1 ,data.terraform_remote_state.network.outputs.subnet2-us-east-1 ]
 desired_capacity    = ${var.desired_capacity}
 max_size            = ${var.max_size}
 min_size            = ${var.min_size}

 launch_template {
   id      = aws_launch_template.ecs_lt_us-east-1.id
   version = "$Latest"
 }

 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }
}



#-------------------------- us-east-2 -------------------------------------

resource "aws_autoscaling_group" "ecs_asg-us-east-2" {
 provider = aws.us_east_2
 vpc_zone_identifier = [data.terraform_remote_state.network.outputs.subnet1-us-east-2 ,data.terraform_remote_state.network.outputs.subnet2-us-east-2 ]
 desired_capacity    = ${var.desired_capacity}
 max_size            = ${var.max_size}
 min_size            = ${var.min_size}

 launch_template {
   id      = aws_launch_template.ecs_lt_us-east-2.id
   version = "$Latest"
 }

 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }
}