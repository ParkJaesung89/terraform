resource "aws_vpc" "jsp_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = format("%s-%s-%s", var.name, terraform.workspace, "vpc")
  }
}
