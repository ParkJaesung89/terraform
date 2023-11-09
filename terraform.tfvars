#####################
# Terraform setting

environment = "dev"
region      = "ap-northeast-2"

tags = {
  MadeBy = "jsp"
}

#####################
# Project name

name = "jsp"

#####################
# Network setting 

vpc_cidr = "10.10.0.0/16"

az_names = [
  "ap-northeast-2a",
  "ap-northeast-2c"
]

public_subnets = {
  pub_sub_2a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.0.0/24"
  },
  pub_sub_2c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.1.0/24"
  }
}

private_subnets = {
  pri_sub_2a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.10.0/24"
  },
  pri_sub_2c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.11.0/24"
  }
}

lb_subnets = {
  lb_sub_2a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.100.0/24"
  },
  lb_sub_2c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.110.0/24"
  }
}

#####################
# Instance setting

instance_disable_termination = true

ec2_type_public  = "t3.micro"
ec2_type_private = "t3.micro"
ec2_volume_size  = 30


#########################
# Secret Groups setting

public_ingress_rules = [
  {
    from_port = "22",
    to_port   = "22",
    cidr      = "211.115.223.215/32"
    desc      = "From jsp SSH(random test ip)"
  },
  {
    from_port = "3389",
    to_port   = "3389",
    cidr      = "211.115.223.215/32"
    desc      = "From jsp RDP(random test ip)"
  }
]

private_ingress_rules = [
  {
    from_port = "25",
    to_port   = "25",
    cidr      = "211.115.223.215/32"
    desc      = "From jsp SMTP(random test ip)"
  },
  {
    from_port = "3306",
    to_port   = "3306",
    cidr      = "211.115.223.215/32"
    desc      = "From jsp HTTP(random test ip)"
  }
]

lb_ingress_rules = [
  {
    from_port = "80",
    to_port   = "80",
    cidr      = "0.0.0.0/0"
    desc      = "From lb http"
  },
  {
    from_port = "443",
    to_port   = "443",
    cidr      = "0.0.0.0/0"
    desc      = "From jsp httpd"
  }
]

db_port = "3306"

#lb_arn = aws_lb.jsp_lb.arn
#lb_listener_port = 80
#lb_listener_protocol = "HTTP"