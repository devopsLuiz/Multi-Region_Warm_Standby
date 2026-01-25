resource "aws_lb" "ecs_alb-us-east-1" {
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb_sg_us_east_1.id]
 subnets            = [data.terraform_remote_state.network.outputs.subnet1-us-east-1,data.terraform_remote_state.network.outputs.subnet2-us-east-1]

 tags = {
   Name = "ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener-us-east-1" {
 load_balancer_arn = aws_lb.ecs_alb-us-east-1.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg-us-east-1.arn
 }
}

resource "aws_lb_target_group" "ecs_tg-us-east-1" {
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = data.terraform_remote_state.network.outputs.vpc_us-east-1

 health_check {
   path = "/"
 }
}

resource "aws_security_group" "alb_sg_us_east_1" {
  name   = "alb-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_us-east-1

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# ---------------------------------- us-east-2 ------------------------------------------------------


resource "aws_lb" "ecs_alb-us-east-2" {
 provider      = aws.us_east_2
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb_sg_us_east_2.id]
 subnets            = [data.terraform_remote_state.network.outputs.subnet1-us-east-2,data.terraform_remote_state.network.outputs.subnet2-us-east-2]

 tags = {
   Name = "ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener-us-east-2" {

 provider      = aws.us_east_2
 load_balancer_arn = aws_lb.ecs_alb-us-east-2.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg-us-east-2.arn
 }
}

resource "aws_lb_target_group" "ecs_tg-us-east-2" {
 provider      = aws.us_east_2
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = data.terraform_remote_state.network.outputs.vpc_us-east-2

 health_check {
   path = "/"
 }
}


resource "aws_security_group" "alb_sg_us_east_2" {
  provider = aws.us_east_2
  name   = "alb-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_us-east-2

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
