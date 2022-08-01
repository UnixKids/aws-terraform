resource "aws_security_group" "ssh-requests" {
  name   = "ssh-requests"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http-requests" {
  name   = "http-requests"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-default-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "alb" {
  count   = local.e2-count
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "terraform-lb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.http-requests.id]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      target_ids = module.ec2-instance.id
    }
  ]

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"

    }
  ]

  tags = {
    Environment = "aws-introduction"
  }
}