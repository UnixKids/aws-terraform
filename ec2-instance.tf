#modules are re-usable code
module "ec2-instance" {
  count         = 4
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "4.1.1"
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  user_data     = file("user_data.sh")
  key_name      = "terraform-test"
  subnet_id     = element(module.vpc.public_subnets, count.index)

  tags = {
    Name = "terraform-instance-${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.ssh-requests.id,
  aws_security_group.http-requests.id]
}


