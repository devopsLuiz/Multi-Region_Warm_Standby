variable "desired_capacity" {

    type = number
    default = 2

}

variable "max_sizes" {

    type = number
    default = 3
    
}


variable "min_size" {

    type = number
    default = 1
    
}

variable "cpu" {

    type = string
    default = "256"
    
}


variable "memory" {

    type = string
    default = "512"
    
}

variable "image" {

    type = string
    default = "xxxxxxxxxxx.dkr.ecr.us-east-2.amazonaws.com/xxxxxxx:projeto"
}