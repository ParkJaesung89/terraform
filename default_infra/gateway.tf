# Internet gateway create
resource "aws_internet_gateway" "jsp-igw" {
  vpc_id = aws_vpc.jsp_vpc.id
  tags = {
    Name = format("%s-%s-%s", var.name, terraform.workspace, "IGW")
  }
}

# NAT gateway Elastic IP create
resource "aws_eip" "jsp_nat_eip" {
  domain = "vpc" #생성 범위 지정
}

# NAT gateway create
resource "aws_nat_gateway" "jsp_nat" {
  count         = 2
  allocation_id = aws_eip.jsp_nat_eip.id #EIP 연결
  subnet_id     = aws_subnet.jsp_pub_sub[count.index].id #NAT가 사용될 서브넷 지정
  tags = {
    Name = format("%s-%s-%s", "jsp", terraform.workspace, "NAT")
  }

  depends_on = [aws_internet_gateway.jsp-igw]
}
