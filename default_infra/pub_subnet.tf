resource "aws_subnet" "jsp_pub_sub" {
  count                   = 2
  vpc_id                  = aws_vpc.jsp_vpc.id
  cidr_block              = "10.10.${count.index}.0/24"
  availability_zone       = "${var.region}${count.index == 0 ? "a" : "c"}"
  map_public_ip_on_launch = true	#auto public eip
  tags ={
    name = "${var.name}-pub-${count.index == 0 ? "a" : "c"}"
  }
}
