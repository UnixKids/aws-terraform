variable "ec2-count" {
  type = number
  default = 5
}

variable "free-tier" {
  type = list(string)
  default = ["t3.micro", "t2.micro"]
}
