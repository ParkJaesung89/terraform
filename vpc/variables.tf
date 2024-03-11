# env - e.g: dev|prd|stage
# variable "environment" {}

# project name
variable "name" {}

# VPC default CIDR
variable "vpc_cidr" {}

# Availability Zones
variable "az_names" {}

# public subnet list
variable "public_subnets" {}

# private subnet list
variable "private_subnets" {}

# lb subnet list
variable "lb_subnets_web" {
    type = list(map(string))        # lb_subnets_web 변수형식을 list로 변경하고 각요소가 map 형식이 되도록 설정
}

#variable "lb_subnets_was" {
#    type = list(map(string))        # lb_subnets_was 변수형식을 list로 변경하고 각요소가 map 형식이 되도록 설정
#}


# rds subnet list
variable "db_subnets" {}

# Tags
variable "tags" {}
