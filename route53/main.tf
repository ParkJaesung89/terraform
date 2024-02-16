
resource "aws_route53_zone" "jsp_route53" {
 name = "jsp-tech.store"
}

resource "aws_route53_record" "www" {
 zone_id = aws_route53_zone.jsp_route53.zone_id
 name = "www"
 type = "A"
 alias {
  evaluate_target_health = true
  name = var.lb_dns_name
  zone_id = var.lb_zone_id
  }
}

