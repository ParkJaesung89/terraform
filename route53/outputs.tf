output "name_servers" {
  value = aws_route53_zone.jsp_route53.name_servers
}


output "acm_arn" {
  value = aws_acm_certificate.jsp_tech_acm.arn
}
    
    