output "ec2-ami" {
  value = data.aws_ami.amazon-linux.image_id
}
output "ec2-ip" {
  value = aws_instance.ec2-instance[*].public_ip
}

output "alb-dns-name" {
  value = aws_lb.terraform-lb.dns_name
}