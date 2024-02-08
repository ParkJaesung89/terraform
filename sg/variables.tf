# Project name
variable "name" {}

# Tags
variable "tags" {}

# public sg rule IP list
variable "public_ingress_rules" {}
variable "public_egress_rules" {}

# private ingress IP list
#variable "private_ingress_rules" {}

# web lb sg rule IP list
variable "web_lb_ingress_rules" {}
variable "web_lb_egress_rules" {}

# was lb sg rule IP list
variable "was_lb_ingress_rules" {}
variable "was_lb_egress_rules" {}


# From module VPC
variable "vpc_id" {}