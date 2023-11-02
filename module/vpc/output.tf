output "vpc_name" {
  value = var.vpc_name
}
output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.my_vpc.id
}

output "igw_id" {
  description = "ID of Internet gateway"
  value       = aws_internet_gateway.my_internet_gateway.id
}

output "eip_id" {
    description = "ID of elastic IP"
    value = aws_eip.elasticIP.id
}

output "nat_id" {
  description = "ID of Natgateway"
  value = aws_nat_gateway.nat-gateway.id
}

output "public_subnet_id" {
  description = "ID of public subnet"
  value = aws_subnet.public-subnet-1.id
  
}

output "private_subnet_id" {
    description = "ID of private subnet"
    value = aws_subnet.private-subnet-1.id
}

output "security_group_id" {
  description = "ID of NGINX security group"
  value = aws_security_group.my-security-group.id
}

output "public_route_table_id" {
  description = "ID of Public route table"
  value = aws_route_table.public-route-table.id
}

output "nat_route_table_id" {
  description = "ID of NAT route table"
  value = aws_route_table.nat-route-table.id
}