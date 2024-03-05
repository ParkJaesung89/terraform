output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "web_lb_subnet_ids" {
  value = module.vpc.web_lb_subnet_ids
}

output "nat_eip" {
  value = module.vpc.nat_eip
}

output "key_pair" {
  value = module.ec2.key_pair
}

output "public_eip" {
  value = module.ec2.public_eip
}

#output "ec2_private_id" {
#  value = module.ec2.ec2_private_id
#}


output "lb_dns_name" {
  value = module.lb.lb_dns_name
}

output "lb_zone_id" {
  value = module.lb.lb_zone_id
}


output "cf_acm_arn" {
  value = module.route53.acm_arn
}


output "cf_dns_name" {
  value = module.cloudfront.cf_dns_name
}

output "cf_zone_id" {
  value = module.cloudfront.cf_zone_id
}

output "waf_acl_arn" {
  value = module.waf.waf_acl_arn
}