# Create a new ec2 instance with code deployment
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

# new IAM role for CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployEC2ServiceRole"
  assume_role_policy = file("aws_role/codedeployrole.json")
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "codedeploy_instance_profile" {
  name = "CodeDeployInstanceProfile"
  role = aws_iam_role.codedeploy_role.name
}

resource "aws_instance" "code_deploy" {
  ami = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_sg.id]
  key_name = var.key_pair

  user_data = file("scripts/codedeployment.sh")

  tags = {
    Name = "code_deploy"
  }
}
