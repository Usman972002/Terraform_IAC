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
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.my_security_group.name]
  root_block_device {
    volume_size = var.ec2_root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "ec2-terraform-instance"
  }
}

