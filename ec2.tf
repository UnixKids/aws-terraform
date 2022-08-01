#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
#data types are lookups or searches
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#resources create aws objects (ec2, S3, load balancers, etc)
resource "aws_instance" "ec2-instance" {

  count = var.ec2-count
  ami = data.aws_ami.amazon-linux.image_id
  instance_type = element(var.free-tier, count.index)
  vpc_security_group_ids = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id]
  subnet_id = element(module.vpc.public_subnets, count.index)
  user_data = file("user_data.sh")
  key_name = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "terraform-instance-${count.index}"
  }
  #we want the aws_key_pair to be created first
  depends_on = [aws_key_pair.ssh-key]
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "ssh-key" {
  public_key = file(".env/terraform_sshkey_rsa.pub")
}