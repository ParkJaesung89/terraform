output "cf_dns_name" {
  value = aws_cloudfront_distribution.cf_dist.domain_name
}

output "cf_zone_id" {
  value = aws_cloudfront_distribution.cf_dist.hosted_zone_id
}
