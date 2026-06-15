output "public_ips" {
  value = aws_instance.name[*].public_ip
}

output "private_ips" {
  value = aws_instance.name[*].private_ip
}

output "instance_ids" {
  value = aws_instance.name[*].id
}

output "instance_names" {
  value = aws_instance.name[*].tags.Name
}