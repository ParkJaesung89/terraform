# env - e.g: dev|prd|stage
variable "environment" {}

# Region - e.g: ap-northeast-2
variable "region" {}

# project name
variable "name" {}

# EC2 instance type
variable "ec2_type_public" {}
variable "ec2_type_private" {}

# EC2 volume size
variable "ec2_volume_size" {}

# EC2 termination protection
variable "instance_disable_termination" {}

# VPC default CIDR
variable "vpc_cidr" {}

# Availability Zones
variable "az_names" {}

# public subnet list
variable "public_subnets" {}

# private subnet list
variable "private_subnets" {}

# lb subnet list
variable "lb_subnets_web" {}
#variable "lb_subnets_was" {}

# Tag
variable "tags" {}

# public sg rule IP list
variable "public_ingress_rules" {}
#variable "public_egress_rules" {}

# private ingress IP list
#variable "private_ingress_rules" {}
variable "private_egress_rules" {}

# web lb sg rule IP list
variable "web_lb_ingress_rules" {}
#variable "web_lb_egress_rules" {}

# web lb sg rule IP list
#variable "was_lb_ingress_rules" {}
#variable "was_lb_egress_rules" {}

# for web_lb
variable "internet_facing" {
  description = "Is the load balancer internal"
  default     = false
}
variable "web_lb_listener_protocol" {
  description = "The protocol for the listener"
  default     = "HTTP"
}
variable "web_lb_listener_port" {
  description = "The port for the listener"
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


## for dns
#variable "domain_name" {
#  description = "The domain name for the SSL certificate"
#}



## for was_lb
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
#  default     = 8080
#}
#
### for web_lb health check
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
