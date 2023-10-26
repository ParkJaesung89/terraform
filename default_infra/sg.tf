# Public Security Group Create
resource "aws_security_group" "jsp_pub_sg" {
  name   = "${var.name}-pub-sg"
  vpc_id = aws_vpc.jsp_vpc.id
  description = "Public security group"

  tags = {
    name = "${var.name}-pub-sg"
  }
}

# Private Security Group Create
resource "aws_security_group" "jsp_pri_sg" {
  name   = "${var.name}-pri-sg"
  vpc_id = aws_vpc.jsp_vpc.id
  description = "Private security group"
 
  tags = {
    name = "${var.name}-pri-sg"
  }
}

# Application Load Balancer Security Group Create
resource "aws_security_group" "jsp_alb_sg" {
  name   = "${var.name}-alb-sg"
  vpc_id = aws_vpc.jsp_vpc.id
  description = "alb security group"

  tags = {
    name = "${var.name}-alb-sg"
  }
}

# Cloud Front Security Group Create
resource "aws_security_group" "jsp_cf_sg" {
  name   = "${var.name}-cf-sg"
  vpc_id = aws_vpc.jsp_vpc.id
  description = "cf security group"

  tags = {
    name = "${var.name}-cf-sg"
  }
}
