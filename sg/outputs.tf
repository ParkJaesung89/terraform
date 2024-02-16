################################################################################
# Subnet Security Group
################################################################################

output "security_group_id_public" {
  value = aws_security_group.public.id
}

output "security_group_id_private" {
  value = aws_security_group.private.id
}

################################################################################
# Application Load Balanser Security Group
################################################################################

#output "security_group_arn" {
#  description = "Amazon Resource Name (ARN) of the security group"
#  value       = module.alb.security_group_arn
#}

output "security_group_id_lb_web" {
  value = aws_security_group.web_lb_sg.id
}

#output "security_group_id_lb_was" {
#  value = aws_security_group.was_lb_sg.id
#}
