output "instance_public_ip" {
  value = aws_instance.backend_app.public_ip
}