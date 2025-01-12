#Export and install codedeployment agent
yum update -y
yum install ruby -y
yum install wget -y

# /home/ec2-user represents the default user name for an Amazon Linux or RHEL Amazon EC2 instance. If your instance was created using a custom AMI, the AMI owner might have specified a different default user name
cd /home/ec2-user
wget https://aws-codedeploy-${var.aws_region}.s3.${var.aws_region}.amazonaws.com/latest/install
./install auto