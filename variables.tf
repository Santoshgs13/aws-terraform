variable "region" {
  default = "ap-south-1"
}
variable "cidr" {
  default = "10.0.0.0/16"
}

variable "cidr_public" {
  default = "10.0.0.0/24"
}

variable "cidr_private" {
  default = "10.0.1.0/24"
}

variable "ami" {
  default = "ami-0f918f7e67a3323f0"
}

variable "instance-type" {
  default = "t2.micro"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}