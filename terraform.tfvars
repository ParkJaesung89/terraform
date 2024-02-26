###################################################################
# Terraform setting
###################################################################

environment = "dev"
#global_region = "us-east-1"
region      = "ap-northeast-2"

tags = {
  MadeBy = "jsp"
}


###################################################################
# Project name
###################################################################

name = "jsp"


###################################################################
# Network setting 
###################################################################

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

lb_subnets_web = [
  {
    zone = "ap-northeast-2a"
    cidr = "10.10.100.0/24"
  },
  {
    zone = "ap-northeast-2c"
    cidr = "10.10.110.0/24"
  }
]

#lb_subnets_was = [
#  {
#    zone = "ap-northeast-2a"
#    cidr = "10.10.200.0/24"
#  },
#  {
#    zone = "ap-northeast-2c"
#    cidr = "10.10.210.0/24"
#  }
#]


###################################################################
# Instance setting
###################################################################

instance_disable_termination = true

ec2_type_public  = "t3.small"
ec2_type_private = "t3.medium"
ec2_volume_size  = 30



###################################################################
# Secret Groups Rule Setting
###################################################################
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

#public_egress_rules = [
#  {
#    from_port = "0",
#    to_port   = "0",
#    cidr      = "0.0.0.0/0"
#    desc      = "to anywhere"
#  }
#]


#private_ingress_rules = [
#  {
#    from_port = "22",
#    to_port   = "22",
#    cidr      = "0.0.0.0/0"
#    desc      = "From jsp SSH(random test ip)"
#  },
#  {
#    from_port = "80",
#    to_port   = "80",
#    cidr      = "0.0.0.0/0"
#    desc      = "to anywhere HTTP)"
#  },
#  {
#    from_port = "443",
#    to_port   = "443",
#    cidr      = "0.0.0.0/0"
#    desc      = "to anywhere HTTP)"
#  }
#]

private_egress_rules = [
  {
    from_port = "0",
    to_port   = "0",
    cidr      = "0.0.0.0/0"
    desc      = "to anywhere"
  }
]


web_lb_ingress_rules = [
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
    desc      = "From lb httpd"
  }
]

#web_lb_egress_rules = [
#  {
#    from_port = "ALL",
#    to_port   = "ALL",
#    cidr      = "0.0.0.0/0"
#    desc      = "to anywhere"
#  }
#]

#was_lb_ingress_rules = [
#  {
#    from_port = "22",
#    to_port   = "22",
#    cidr      = "0.0.0.0/0"
#    desc      = "From bastion"
#  },
#  {
#    from_port = "80",
#    to_port   = "80",
#    cidr      = "0.0.0.0/0"
#    desc      = "From lb http"
#  }
#]

#was_lb_egress_rules = [
#  {
#    from_port = "0",
#    to_port   = "0",
#    cidr      = "0.0.0.0/0"
#    desc      = "to anywhere"
#  }
#]


###################################################################
# DB port
###################################################################
#db_port = "3306"


#web_lb
web_lb_listener_port_http = 80
web_lb_listener_protocol_http = "HTTP"

web_lb_listener_port_https = 443
web_lb_listener_protocol_https = "HTTPS"

internet_facing = false
web_health_check_path  = "/health/index.html"
web_health_check_timeout = 5
web_health_check_interval = 30
web_healthy_threshold = 2
web_unhealthy_threshold = 2


##was_lb
#was_lb_listener_port = 80
#was_lb_listener_protocol = "HTTP"
#
#internal        = true
#was_health_check_path  = "/health"
#was_health_check_timeout = 5
#was_health_check_interval = 30
#was_healthy_threshold = 2
#was_unhealthy_threshold = 2
