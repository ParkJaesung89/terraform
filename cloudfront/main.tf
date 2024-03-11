#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  aliases             = ["www.jsp-tech.store"]
  origin {
    domain_name = var.lb_dns_name
    origin_id   = var.lb_dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    custom_header {
      name  = var.custom_header
      value = var.custom_header_value
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.lb_dns_name
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = ["*"]
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["KR", "US"]
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn          = var.cf_acm_arn
    ssl_support_method           = "sni-only"
    minimum_protocol_version     = "TLSv1.2_2021"
  }

  web_acl_id = var.waf_acl_arn

  tags = merge(
    {
      Name = format(
        "%s-%s-cf",
        var.name,
        terraform.workspace
      )
    },
    var.tags,
  ) 
}
