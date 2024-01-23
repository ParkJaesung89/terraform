

# for ec2
variable "name" {}
variable "tags" {}
variable "lb_subnets" {}
#variable "lb_subnet_ids" {}

#  From module SG
variable "security_group_id_lb" {}

# From module VPC
variable "vpc_id" {}

# for lb
variable "internal" {
  description = "Is the load balancer internal"
  default     = false
}
variable "lb_listener_protocol" {
  description = "The protocol for the listener"
  default     = "HTTP"
}
variable "lb_listener_port" {
  description = "The port for the listener"
  default     = 80
}

variable "lb_tg_protocol" {
  description = "The port for the lb target group"
  default     = "HTTP"
}

variable "lb_tg_port" {
  description = "The port for the lb target group"
  default     = 80
}

# for health check
variable "health_check_path" {
  description = "The health check path"
  default     = "/health"
}

variable "health_check_timeout" {
  description = "The health check timeout"
  default     = 5
}

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