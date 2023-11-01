
variable "ami_value" {
  description = "Value of the ami"
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type_value" {
  description = "Value of the instance type"
  default     = "t2.micro"
}
 

variable "security_group_id"{}

variable "public_subnet_id" {}

variable "public_ec2_name" {}

variable "private_subnet_id"{}

variable "private_ec2_name" {}
