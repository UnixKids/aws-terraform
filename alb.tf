#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#load balancer routes traffic between ec2 instances over port 80
resource "aws_lb" "terraform-lb" {

  name = "terraform-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.allow-http.id]
  subnets = module.vpc.public_subnets

  tags = {
    Name: "terraform-test"
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "terraform-tg" {
  name = "terraform-target-group"
  port = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "terraform-lb-attachment" {
  count = var.ec2-count
  target_group_arn = aws_lb_target_group.terraform-tg.arn
  target_id        = aws_instance.ec2-instance[count.index].id
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "terraform-http" {

  load_balancer_arn = aws_lb.terraform-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.terraform-tg.arn
  }
}