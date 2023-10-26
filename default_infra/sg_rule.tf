# Security Group Rules

# Public Security Group Rules

resource "aws_security_group_rule" "pub_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jsp_pub_sg.id
}  

resource "aws_security_group_rule" "pub_ssh" {
  type         = "ingress"
  from_port    = 22
  to_port      = 22
  protocol     = "tcp"
  cidr_blocks   = ["211.115.223.215/32"]
  security_group_id = aws_security_group.jsp_pub_sg.id
}

resource "aws_security_group_rule" "pub_http" {
  type         = "ingress"
  from_port    = 80
  to_port      = 80
  protocol     = "tcp"
  cidr_blocks   = ["211.115.223.215/32"]
  security_group_id = aws_security_group.jsp_pub_sg.id
}

resource "aws_security_group_rule" "pub_https" {
  type         = "ingress"
  from_port    = 443
  to_port      = 443
  protocol     = "tcp"
  cidr_blocks   = ["211.115.223.215/32"]
  security_group_id = aws_security_group.jsp_pub_sg.id
}

resource "aws_security_group_rule" "pub_8080" {
  type         = "ingress"
  from_port    = 8080
  to_port      = 8080
  protocol     = "tcp"
  cidr_blocks   = ["211.115.223.215/32"]
  security_group_id = aws_security_group.jsp_pub_sg.id
}




# Private Security Group Rules

resource "aws_security_group_rule" "pri_outbound" {
  type         = "egress"
  from_port    = 3306
  to_port      = 3306
  protocol     = "tcp"
  cidr_blocks   = [var.pub_cidr]
  security_group_id = aws_security_group.jsp_pri_sg.id
}

resource "aws_security_group_rule" "pri_ssh" {
  type         = "ingress"
  from_port    = 22
  to_port      = 22
  protocol     = "tcp"
  cidr_blocks   = ["211.115.223.215/32"]
  security_group_id = aws_security_group.jsp_pri_sg.id
  source_security_group_id = aws_security_group.jsp_pub_sg.id
}

resource "aws_security_group_rule" "pri_mysql" {
  type         = "ingress"
  from_port    = 3306
  to_port      = 3306
  protocol     = "tcp"
  #cidr_blocks   = ["211.115.223.215/32"]
  security_group_id = aws_security_group.jsp_pri_sg.id
  source_security_group_id = aws_security_group.jsp_pub_sg.id
}




# Application Load Balancer Security Group Rules

# outbound
resource "aws_security_group_rule" "alb_out_mysql" {
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jsp_alb_sg.id
  
  lifecycle {
    create_before_destroy = true
  }
}  

# inbound
resource "aws_security_group_rule" "alb_in_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jsp_alb_sg.id
  source_security_group_id = aws_security_group.jsp_cf_sg.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_in_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jsp_alb_sg.id
  source_security_group_id = aws_security_group.jsp_cf_sg.id

  lifecycle {
    create_before_destroy = true
  }
}
