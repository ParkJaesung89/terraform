output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  value = values(aws_subnet.private)[*].id
}

output "web_lb_subnet_ids" {
  value = values(aws_subnet.web_lb)[*].id
}

#output "was_lb_subnet_ids" {
#  value = values(aws_subnet.was_lb)[*].id
#}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}
