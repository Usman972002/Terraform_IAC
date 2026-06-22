resource "aws_key_pair" "my_key_pair" {
  key_name   = "ec2-terraform-key"
  public_key = file("ec2-terraform-key.pub")
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_security_group" {
  name        = "ec2-terraform-security-group"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "ec2-terraform-security-group"
  }

}

# Ec2 instance
resource "aws_instance" "my_ec2_instance" {
# count           = 2 # META argument for creating multiple ec2 servers
  for_each        = tomap({
                          aws-micro = "t3.micro"
                          aws-small = "t3.small"
                        })
  ami             = var.ec2_ami_id
  depends_on      = [aws_security_group.my_security_group] # This will work as a dependency 
# instance_type   = var.ec2_instance_type
  instance_type   = each.value # This will select the value under for_each (t3.micro)
  key_name        = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.my_security_group.name]
  user_data       = file("install.sh")
  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    #volume_size = var.ec2_root_volume_size
    volume_type = "gp3"
  }

  tags = {
#    Name = "ec2-terraform-instance"
     Name = each.key  # This will select the key under for_each (aws-micro)
  }
}

