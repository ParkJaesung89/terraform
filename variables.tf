# env - e.g: dev|prd|stage
variable "environment" {}

# Region - e.g: ap-northeast-2
variable "region" {}

# project name
variable "name" {}

# EC2 instance type
variable "ec2_type_public" {}
#variable "ec2_type_private" {}

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
#variable "private_subnets" {}

# lb subnet list
variable "lb_subnets" {}

# Tag
variable "tags" {}

# public ingress IP list
variable "public_ingress_rules" {}

# private ingress IP list
#variable "private_ingress_rules" {}

# lb ingress IP list
variable "lb_ingress_rules" {}

# DB port
variable "db_port" {}

# for lb
variable "internal" {
  description = "Is the load balancer internal"
  default     = false
}
variable "lb_listener_protocol" {
  description = "The protocol for the listener"
  default     = "http"
}
variable "lb_listener_port" {
  description = "The port for the listener"
  default     = 80
}

## for health check
variable "health_check_path" {
  description = "The health check path"
  default     = "/health"
}
#
variable "health_check_timeout" {
  description = "The health check timeout"
  default     = 5
}
#
variable "health_check_interval" {
  description = "The health check interval"
  default     = 30
}

variable "healthy_threshold" {
  description = "The healthy threshold"
  default     = 2
}

variable "unhealthy_threshold" {
  description = "The unhealthy threshold"
  default     = 2
}

# for lb_listener
#variable "lb_arn" {}

## for dns
#variable "domain_name" {
#  description = "The domain name for the SSL certificate"
#}