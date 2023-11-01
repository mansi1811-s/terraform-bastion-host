output "public-ec2" {
    description = "Id of Public ec2 instance "
    value= aws_instance.public-ec2.id
}
output "private-ec2" {
  description = "Id of Private ec2 instance "
    value= aws_instance.private-ec2.id
}
