output "aws_ip" {
  value = module.ec2-instance[*].public_ip
}

output "aws_id" {
  value = module.ec2-instance[*].id
}

output "aws_keys" {
  value = aws_key_pair.terraform-keys.public_key
}

output "lb_info" {
  value = module.alb[*].lb_dns_name
}