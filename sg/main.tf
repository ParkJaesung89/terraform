######################################
## Security Groups

locals {
  public_sg  = format("%s-%s-sg", var.name, "public")
  private_sg = format("%s-%s-sg", var.name, "private")
  web_lb_sg  = format("%s-%s-sg", var.name, "web-lb")
  #was_lb_sg  = format("%s-%s-sg", var.name, "was-lb")
}


# public sg
resource "aws_security_group" "public" {
  name        = local.public_sg
  description = "public security group for ${var.name}"
  vpc_id      = var.vpc_id


  # inbound rule
  dynamic "ingress" {
    for_each = [for s in var.public_ingress_rules : {
      from_port = s.from_port
      to_port   = s.to_port
      desc      = s.desc
      cidrs     = [s.cidr]
    }]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidrs
      protocol    = "tcp"
      description = ingress.value.desc
    }
  }

#  # outbound rule
#    dynamic "egress" {
#    for_each = [for s in var.public_egress_rules : {
#      from_port = s.from_port
#      to_port   = s.to_port
#      desc      = s.desc
#      cidrs     = [s.cidr]
#    }]
#    content {
#      from_port   = egress.value.from_port
#      to_port     = egress.value.to_port
#      cidr_blocks = egress.value.cidrs
#      protocol    = "ALL"
#      description = egress.value.desc
#    }
#  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = local.public_sg
    },
    var.tags
  )
}

# private sg
resource "aws_security_group" "private" {
  name        = local.private_sg
  description = "private security group for ${var.name}"
  vpc_id      = var.vpc_id

#  # inbound rule
#  dynamic "ingress" {
#    for_each = [for s in var.private_ingress_rules : {
#      from_port = s.from_port
#      to_port   = s.to_port
#      desc      = s.desc
#      cidrs     = [s.cidr]
#    }]
#    content {
#      from_port   = ingress.value.from_port
#      to_port     = ingress.value.to_port
#      cidr_blocks = ingress.value.cidrs
#      protocol    = "tcp"
#      description = ingress.value.desc
#    }
#  }

#  # outbound rule
#    dynamic "egress" {
#    for_each = [for s in var.private_egress_rules : {
#      from_port = s.from_port
#      to_port   = s.to_port
#      desc      = s.desc
#      cidrs     = [s.cidr]
#    }]
#    content {
#      from_port   = egress.value.from_port
#      to_port     = egress.value.to_port
#      cidr_blocks = egress.value.cidrs
#      protocol    = "tcp"
#      description = egress.value.desc
#    }
#  }

  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = local.private_sg
    },
    var.tags
  )
}

resource "aws_security_group_rule" "private_bastion_ingress" {
  type				= "ingress"
  from_port			= "22"
  to_port			= "22"
  protocol			= "TCP"
  security_group_id		= "${aws_security_group.private.id}"
  source_security_group_id 	= "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "private_http_lb_ingress" {
  type                          = "ingress"
  from_port                     = "80"
  to_port                       = "80"
  protocol                      = "TCP"
  security_group_id             = "${aws_security_group.private.id}"
  source_security_group_id      = "${aws_security_group.web_lb_sg.id}"
}

resource "aws_security_group_rule" "private_https_lb_ingress" {
  type                          = "ingress"
  from_port                     = "443"
  to_port                       = "443"
  protocol                      = "TCP"
  security_group_id             = "${aws_security_group.private.id}"
  source_security_group_id      = "${aws_security_group.web_lb_sg.id}"
}

# web Load Balancer sg
resource "aws_security_group" "web_lb_sg" {
  name        = local.web_lb_sg
  description = "WEB LB security group for ${var.name}"
  vpc_id      = var.vpc_id


  # inbound rule
  dynamic "ingress" {
    for_each = [for s in var.web_lb_ingress_rules : {
      from_port = s.from_port
      to_port   = s.to_port
      desc      = s.desc
      cidrs     = [s.cidr]
    }]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidrs
      protocol    = "tcp"
      description = ingress.value.desc
    }
  }

  # self refer
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
    description = "Self Refer"
  }

#  # outbound rule
#  dynamic "egress" {
#    for_each = [for s in var.web_lb_egress_rules : {
#      from_port = s.from_port
#      to_port   = s.to_port
#      desc      = s.desc
#      cidrs     = [s.cidr]
#    }]
#    content {
#      from_port   = egress.value.from_port
#      to_port     = egress.value.to_port
#      cidr_blocks = egress.value.cidrs
#      protocol    = "tcp"
#      description = egress.value.desc
#    }
#  }

  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = local.web_lb_sg
    },
    var.tags
  )
}


## was Load Balancer sg
#resource "aws_security_group" "was_lb_sg" {
#  name        = local.was_lb_sg
#  description = "WAS LB security group for ${var.name}"
#  vpc_id      = var.vpc_id
#
#
#  # inbound rule
#  dynamic "ingress" {
#    for_each = [for s in var.was_lb_ingress_rules : {
#      from_port = s.from_port
#      to_port   = s.to_port
#      desc      = s.desc
#      cidrs     = [s.cidr]
#    }]
#    content {
#      from_port   = ingress.value.from_port
#      to_port     = ingress.value.to_port
#      cidr_blocks = ingress.value.cidrs
#      protocol    = "tcp"
#      description = ingress.value.desc
#    }
#  }
#
#  # self refer
#  ingress {
#    from_port   = "0"
#    to_port     = "0"
#    protocol    = "-1"
#    self        = true
#    description = "Self Refer"
#  }
#
#  dynamic "egress" {
#    for_each = [for s in var.was_lb_egress_rules : {
#      from_port = s.from_port
#      to_port   = s.to_port
#      desc      = s.desc
#      cidrs     = [s.cidr]
#    }]
#    content {
#      from_port   = egress.value.from_port
#      to_port     = egress.value.to_port
#      cidr_blocks = egress.value.cidrs
#      protocol    = "tcp"
#      description = egress.value.desc
#    }
#  }
#  
#  tags = merge(
#    {
#      Name = local.was_lb_sg
#    },
#    var.tags
#  )
#}
