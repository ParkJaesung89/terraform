# public routing
resource "aws_route_table" "jsp_pub_rt" {
  vpc_id = aws_vpc.jsp_vpc.id #VPC 별칭 입력
  route {
    cidr_block = var.pub_cidr
    gateway_id = "aws_internet_gateway.jsp-igw.id" #Internet Gateway 별칭 입력
  }
  tags = {
    Name = "${var.name}-pub-rt-${terraform.workspace}"
  } #태그 설정
}

# pubilc route table association
resource "aws_route_table_association" "jsp_pub_rt_association" {
  count          = 2
  subnet_id      = aws_subnet.jsp_pub_sub[count.index].id
  route_table_id = aws_route_table.jsp_pub_rt.id
}




# private routing
resource "aws_route_table" "jsp_pri_rt" {
  vpc_id = aws_vpc.jsp_vpc.id #VPC 별칭 입력
  route {
    cidr_block = var.pub_cidr
    gateway_id = "aws_nat_gateway.nat.id" #NAT Gateway 별칭 입력
  }
  tags = {
    Name = "${var.name}-pri-rt-${terraform.workspace}"
  } #태그 설정
}

# private route table association
resource "aws_route_table_association" "jsp_pri_rt_association" {
  count          = 2
  subnet_id      = aws_subnet.jsp_pri_sub[count.index].id
  route_table_id = aws_route_table.jsp_pri_rt.id
}

