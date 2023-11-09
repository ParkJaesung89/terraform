

# for ec2
variable "name" {}
variable "tags" {}
variable "lb_subnets" {}

# for vpc
#variable "lb_sub_ids" {}

#  From module SG
variable "security_group_id_lb" {}

# From module VPC
variable "vpc_id" {}

# for lb_listener
#variable "lb_arn" {}
#variable "lb_listener_port" {}
#variable "lb_listener_protocol" {}