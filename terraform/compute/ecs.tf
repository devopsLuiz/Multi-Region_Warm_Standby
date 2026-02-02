resource "aws_ecs_cluster" "ecs_cluster-us-east-1" {

 name = "app-ecs-cluster-us-east-1"

}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider-us-east-1" {
 name = "app-capacity_provider-us-east-1"

 auto_scaling_group_provider {
   auto_scaling_group_arn = aws_autoscaling_group.ecs_asg-us-east-1.arn

   managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
 }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers-us-east-1" {
 cluster_name = aws_ecs_cluster.ecs_cluster-us-east-1.name

 capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider-us-east-1.name]

 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider-us-east-1.name
 }
}

resource "aws_ecs_task_definition" "ecs_task_definition-us-east-1" {
  family                   = "app-ecs-task-us-east-1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"] 
  cpu                      = ${var.cpu}
  memory                   = ${var.memory}

  

  execution_role_arn = data.terraform_remote_state.security.outputs.ecs_task_execution_role

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = ${var.image}
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "ecs_service-us-east-1" {
 name            = "app-ecs-service"
 cluster         = aws_ecs_cluster.ecs_cluster-us-east-1.id
 task_definition = aws_ecs_task_definition.ecs_task_definition-us-east-1.arn
 desired_count   = 2
 health_check_grace_period_seconds = 60

 network_configuration {
   subnets         = [data.terraform_remote_state.network.outputs.subnet1-us-east-1, data.terraform_remote_state.network.outputs.subnet2-us-east-1]
   security_groups = [aws_security_group.ecs_service_sg_us_east_1.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }


 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider-us-east-1.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.ecs_tg-us-east-1.arn
   container_name   = "dockergs"
   container_port   = 80
 }

 depends_on = [aws_lb_listener.ecs_alb_listener-us-east-1]
}


resource "aws_security_group" "ecs_service_sg_us_east_1" {
  name   = "ecs-service-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_us-east-1

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_us_east_1.id]
    description     = "Allow ALB to ECS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#----------------------------------------- us-east-2 -------------------------------------


resource "aws_ecs_cluster" "ecs_cluster-us-east-2" {

 provider      = aws.us_east_2
 name = "app-ecs-cluster-us-east-2"
 
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider-us-east-2" {
 provider      = aws.us_east_2
 name = "app-capacity_provider-us-east-2"

 auto_scaling_group_provider {
   auto_scaling_group_arn = aws_autoscaling_group.ecs_asg-us-east-2.arn

   managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
 }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers-us-east-2" {
 provider      = aws.us_east_2
 cluster_name = aws_ecs_cluster.ecs_cluster-us-east-2.name

 capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider-us-east-2.name]

 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider-us-east-2.name
 }
}

resource "aws_ecs_task_definition" "ecs_task_definition-us-east-2" {
  provider      = aws.us_east_2
  family                   = "app-ecs-task-us-east-2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"] 
  cpu                      = ${var.cpu}
  memory                   = ${var.memory}

  execution_role_arn = data.terraform_remote_state.security.outputs.ecs_task_execution_role

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = ${var.image}
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "ecs_service-us-east-2" {

 provider      = aws.us_east_2
 name            = "app-ecs-service"
 cluster         = aws_ecs_cluster.ecs_cluster-us-east-2.id
 task_definition = aws_ecs_task_definition.ecs_task_definition-us-east-2.arn
 desired_count   = 2
 health_check_grace_period_seconds = 60

 network_configuration {
   subnets         = [data.terraform_remote_state.network.outputs.subnet1-us-east-2, data.terraform_remote_state.network.outputs.subnet2-us-east-2]
   security_groups = [aws_security_group.ecs_service_sg_us_east_2.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }


 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider-us-east-2.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.ecs_tg-us-east-2.arn
   container_name   = "dockergs"
   container_port   = 80
 }

 depends_on = [aws_lb_listener.ecs_alb_listener-us-east-2]
}

resource "aws_security_group" "ecs_service_sg_us_east_2" {
  provider = aws.us_east_2
  name   = "ecs-service-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_us-east-2

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_us_east_2.id]
    description     = "Allow ALB to ECS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
