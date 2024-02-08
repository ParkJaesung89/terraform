output "web_lb_tg_arn" {
    value = aws_lb_target_group.web_lb_tg.arn
}

#output "lb_dns_name" {
#  value = aws_lb.jsp_lb.dns_name
#}

#output "certificate_arn" {
#  value = aws_acm_certificate.jsp_acm.arn
#}