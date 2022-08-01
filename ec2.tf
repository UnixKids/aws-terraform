locals {
  e2-count = 4
}
resource "aws_key_pair" "terraform-keys" {
  key_name   = "terraform-test"
  public_key = file(".env/terraform_example_rsa.pub")
}

resource "aws_alb_target_group_attachment" "lb-http-targets" {
  count            = local.e2-count
  target_group_arn = module.ec2-instance[count.index].arn
  target_id        = element(module.ec2-instance.*.id, count.index)
}
