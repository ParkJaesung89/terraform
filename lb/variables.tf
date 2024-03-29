

# for ec2
variable "name" {}
variable "tags" {}
variable "lb_subnets_web" {}
#variable "lb_subnets_was" {}

#  From module SG
variable "security_group_id_lb_web" {}
#variable "security_group_id_lb_was" {}

# From module VPC
variable "vpc_id" {}

# From module route53
variable "certificate_arn" {}
variable "acm_validation" {}

# for web_lb
variable "internet_facing" {
  description = "Is the load balancer internal"
  default     = false
}
variable "web_lb_listener_protocol_http" {
  description = "The protocol for the listener"
  default     = "HTTP"
}
variable "web_lb_listener_protocol_https" {
  description = "The protocol for the listener"
  default     = "HTTPS"
}
variable "web_lb_listener_port_http" {
  description = "The port for the listener"
  default     = 80
}

variable "web_lb_listener_port_https" {
  description = "The port for the listener"
  default     = 443
}

variable "web_lb_tg_protocol" {
  description = "The port for the lb target group"
  default     = "HTTP"
}

variable "web_lb_tg_port" {
  description = "The port for the lb target group"
  default     = 80
}

## for web_lb health check
variable "web_health_check_path" {
  description = "The health check path"
  default     = "/health"
}
#
variable "web_health_check_timeout" {
  description = "The health check timeout"
  default     = 5
}
#
variable "web_health_check_interval" {
  description = "The health check interval"
  default     = 30
}

variable "web_healthy_threshold" {
  description = "The healthy threshold"
  default     = 2
}

variable "web_unhealthy_threshold" {
  description = "The unhealthy threshold"
  default     = 2
}

variable "web_health_check_matcher" {
  description = "The healthy code match"
  default     = "200,301"
}

##############
### ACM module
##############



## for dns
#variable "domain_name" {
#  description = "The domain name for the SSL certificate"
#}



# for was_lb
#variable "internal" {
#  description = "Is the load balancer internal"
#  default     = true
#}
#variable "was_lb_listener_protocol" {
#  description = "The protocol for the listener"
#  default     = "HTTP"
#}
#variable "was_lb_listener_port" {
#  description = "The port for the listener"
#  default     = 80
#}
#
#variable "was_lb_tg_protocol" {
#  description = "The port for the lb target group"
#  default     = "HTTP"
#}

#variable "was_lb_tg_port" {
#  description = "The port for the lb target group"
#  default     = 8080
#}

## for web_lb health check
#variable "was_health_check_path" {
#  description = "The health check path"
#  default     = "/health"
#}
#
#variable "was_health_check_timeout" {
#  description = "The health check timeout"
#  default     = 5
#}
#
#variable "was_health_check_interval" {
#  description = "The health check interval"
#  default     = 30
#}
#
#variable "was_healthy_threshold" {
#  description = "The healthy threshold"
#  default     = 2
#}
#
#variable "was_unhealthy_threshold" {
#  description = "The unhealthy threshold"
#  default     = 2
#}
