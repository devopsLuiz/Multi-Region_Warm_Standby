resource "aws_vpc" "vpc_main_us-east-1" {

    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    
}

resource "aws_internet_gateway" "ig-us-east-1"{

    vpc_id = aws_vpc.vpc_main_us-east-1.id

}

resource "aws_subnet" "subnet1-us-east-1" {
 vpc_id                  = aws_vpc.vpc_main_us-east-1.id
 cidr_block              = cidrsubnet(aws_vpc.vpc_main_us-east-1.cidr_block, 8, 1)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1a"
}

resource "aws_subnet" "subnet2-us-east-1" {
 vpc_id                  = aws_vpc.vpc_main_us-east-1.id
 cidr_block              = cidrsubnet(aws_vpc.vpc_main_us-east-1.cidr_block, 8, 2)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1b"
}


resource "aws_route_table" "route_table-us-east-1" {
 vpc_id = aws_vpc.vpc_main_us-east-1.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.ig-us-east-1.id
 }
}

resource "aws_route_table_association" "subnet_route-us-east-1" {
 subnet_id      = aws_subnet.subnet1-us-east-1.id
 route_table_id = aws_route_table.route_table-us-east-1.id
}

resource "aws_route_table_association" "subnet2_route-us-east-1" {
 subnet_id      = aws_subnet.subnet2-us-east-1.id
 route_table_id = aws_route_table.route_table-us-east-1.id
}

resource "aws_security_group" "security_group-us-east-1" {
 name   = "ecs-security-group"
 vpc_id = aws_vpc.vpc_main_us-east-1.id

 ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

#----------------- us-east-2 -------------------------------------------



resource "aws_vpc" "vpc_main_us-east-2" {

    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    provider = aws.us_east_2

}

resource "aws_internet_gateway" "ig-us-east-2"{

    provider = aws.us_east_2
    vpc_id = aws_vpc.vpc_main_us-east-2.id
    
}

resource "aws_subnet" "subnet1-us-east-2" {
 provider = aws.us_east_2
 vpc_id                  = aws_vpc.vpc_main_us-east-2.id
 cidr_block              = cidrsubnet(aws_vpc.vpc_main_us-east-2.cidr_block, 8, 1)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-2a"
}

resource "aws_subnet" "subnet2-us-east-2" {
 provider = aws.us_east_2
 vpc_id                  = aws_vpc.vpc_main_us-east-2.id
 cidr_block              = cidrsubnet(aws_vpc.vpc_main_us-east-2.cidr_block, 8, 2)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-2b"
}


resource "aws_route_table" "route_table-us-east-2" {
 provider = aws.us_east_2
 vpc_id = aws_vpc.vpc_main_us-east-2.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.ig-us-east-2.id
 }
}

resource "aws_route_table_association" "subnet_route-us-east-2" {
 provider = aws.us_east_2   
 subnet_id      = aws_subnet.subnet1-us-east-2.id
 route_table_id = aws_route_table.route_table-us-east-2.id
}

resource "aws_route_table_association" "subnet2_route-us-east-2" {
 provider = aws.us_east_2
 subnet_id      = aws_subnet.subnet2-us-east-2.id
 route_table_id = aws_route_table.route_table-us-east-2.id
}

resource "aws_security_group" "security_group-us-east-2" {
 provider = aws.us_east_2
 name   = "ecs-security-group"
 vpc_id = aws_vpc.vpc_main_us-east-2.id

 ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
