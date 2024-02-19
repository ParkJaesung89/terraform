
resource "aws_route53_zone" "jsp_route53" {
 name = "jsp-tech.store"
}

## ACM
resource "aws_acm_certificate" "jsp_tech_acm" {
    domain_name       = "jsp-tech.store"
    validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
    #provider = aws.us_east_1
    subject_alternative_names = [ "*.jsp-tech.store" ]
    
    tags = {
      Name = format(
        "%s-%s-acm",
        var.name,
        terraform.workspace
      )
    }
}

resource "aws_route53_record" "acm_record" {
  for_each = {
    for dvo in aws_acm_certificate.jsp_tech_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.jsp_route53.zone_id
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.jsp_tech_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_record : record.fqdn]
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


