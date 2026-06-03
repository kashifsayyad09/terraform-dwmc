output "instance_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.dev[*].public_ip
}

output "instance_id" {
  description = "out name id"
  value       = aws_instance.dev[*].id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}