# Create a new ec2 instance
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  profile = var.profile
}

resource "aws_vpc" "app_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "app_subnet" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "app_sg" {
    vpc_id = aws_vpc.app_vpc.id
    name = "app_sg"
    description = "Allow traffic"

# Allow HTTP traffic
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

# Allow SSH traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "backend_app" {
  ami = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_sg.id]
  key_name = var.key_pair

  tags = {
    Name = "backend_app"
  }
}
