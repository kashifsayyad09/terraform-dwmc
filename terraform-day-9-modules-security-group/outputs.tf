output "ec2_sg_id" {
  value = aws_security_group.name.id
}

output "rds_sg_id" {
  value = aws_security_group.name2.id
}

