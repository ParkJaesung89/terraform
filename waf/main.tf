terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.us-east-1]
    }
  }
}


#############################################################
### WAF - Cloudfront
#############################################################

# ip_sets block for cloudfront
resource "aws_wafv2_ip_set" "ipset_global" {
  provider          = aws.us-east-1
  name                  = "block_ips"
  scope                 = "CLOUDFRONT"
  ip_address_version    = "IPV4"
  addresses             = var.waf_ip_sets
}

# Create Waf
resource "aws_wafv2_web_acl" "waf_acl" {
  provider          = aws.us-east-1
  name                  = "${var.waf_prefix}-generic-acl"
  scope                 = "CLOUDFRONT"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled  = true
    sampled_requests_enabled    = true
    metric_name                 = "global-rule"
  }

  # Create managed rule
  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name      = rule.value.name
      priority  = rule.value.priority
      override_action {
        count {}           # allow, block 으로 지정하지 않고 다음 룰에 결정을 넘기는 값.
      }
      statement {
        managed_rule_group_statement {
          name  = rule.value.name
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled  = true
        sampled_requests_enabled    = true
        metric_name                 = rule.value.name
      }
    }
  }
  
  # Create ip_sets block rule
  rule {
    name = "block_ips"
    priority = 1
    action {
        allow {}        # 차단은 block{}, 허용할거면 allow{}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset_global.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled    = true
      sampled_requests_enabled      = true
      metric_name                   = "block_ips"
    }
  }
}


# Create cloudwatch log group
resource "aws_cloudwatch_log_group" "waf_logging" {
  provider          = aws.us-east-1
  name = "aws-waf-logs-${var.waf_prefix}"
}


# Enable waf logging
resource "aws_wafv2_web_acl_logging_configuration" "logging_configuration" {
  provider          = aws.us-east-1
  log_destination_configs   = [aws_cloudwatch_log_group.waf_logging.arn]
  resource_arn              = aws_wafv2_web_acl.waf_acl.arn
}




#############################################################
### WAF - Alb
#############################################################

## Create regex pattern set
#resource "aws_wafv2_regex_pattern_set" "http_headers" {
#  name = "HTTP-headers"
#  description = "HTTP headers regex pattern set"
#  scope = "REGIONAL"
#  
#  dynamic "regular_expression" {
#    for_each = var.http_headers_val_to_block
#    content {
#      regex_string = regular_expression.value
#    }
#  }
#}


resource "aws_wafv2_rule_group" "check_cloudfront_header" {
  name        = "check-cloudfront-header"
  description = "If CloudFront headers do not match, handle it by blocking."
  scope       = "REGIONAL"
  capacity    = "500"

  rule {
    name     = "block-header-rule"
    priority = 1

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "jsp-tech"
              }
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "EXACTLY"
            search_string         = "qkrwotjd89"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "ALB-WAF-ACL-Rule-Metric"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "ALB-WAF-ACL-Metric"
  }
}

# Create waf_acl for ALB
resource "aws_wafv2_web_acl" "alb_waf_acl" {
  name                  = "${var.waf_prefix}-alb-acl"
  scope                 = "REGIONAL"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled  = true
    sampled_requests_enabled    = true
    metric_name                 = "alb-waf-rule"
  }

  # Create header check rule
  rule {
    name = "cloudfront_header_checks"
    priority = 0
    override_action {
        none {}        # none{} - rule group action 따라감, count{} - rule은 있지만 action은 안하고 다음 순서로 넘김
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.check_cloudfront_header.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled    = true
      sampled_requests_enabled      = true
      metric_name                   = "cloudfront_header_Metric"
    }
  }
}
