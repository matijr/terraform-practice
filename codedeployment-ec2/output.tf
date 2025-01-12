output "instance_public_ip" {
  value = aws_instance.code_deploy.public_ip
}