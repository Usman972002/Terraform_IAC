variable "ec2_instance_type" {
    default = "t3.micro"
    type    = string
}

variable "ec2_root_volume_size" {
    default = 15
    type    = number
}

variable "ec2_ami_id" {
    default = "ami-0b6d9d3d33ba97d99"
    type    = string
}


