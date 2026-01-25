output "vpc_us-east-1"{

    description = "Get vpc for us-east-1"
    value = aws_vpc.vpc_main_us-east-1.id
}


output "vpc_us-east-2"{

    description = "Get vpc for us-east-2"
    value = aws_vpc.vpc_main_us-east-2.id
}

output "security_groups-us-east-1" {


    description = "Get sg for us-east-1"
    value = aws_security_group.security_group-us-east-1.id
}

output "security_groups-us-east-2" {


    description = "Get sg for us-east-2"
    value = aws_security_group.security_group-us-east-2.id
}

output "subnet1-us-east-1"{

    value = aws_subnet.subnet1-us-east-1.id
}

output "subnet2-us-east-1"{

    value = aws_subnet.subnet2-us-east-1.id
}


output "subnet1-us-east-2"{

    value = aws_subnet.subnet1-us-east-2.id
}

output "subnet2-us-east-2"{

    value = aws_subnet.subnet2-us-east-2.id
}