variable "waf_prefix" {
  type = string
  default = "www-jsp-tech-store"
}

variable "waf_ip_sets" {
  type = list(string)
  default = ["0.0.0.0/1", "128.0.0.0/1"]     #waf는 CIDR의 "/0" 를 제외한 모든 범위를 지원하기 때문에 모든 범위 설정
}

variable "ip_set_rule" {
  type = list(object ({
    name        = string
    priority    = number
    ip_set_arn  = string
    action      = string
  }))
  description = "A rule to detect web requests coming particular IP addresses or address ranges."
    default     = []
}

variable "managed_rules" {
  description = "List of AWS Managed WAF Rules"
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
    }))
    default = [
        {
          name              = "AWSManagedRulesAdminProtectionRuleSet"
          priority          = 10
          override_action   = "none"
          excluded_rules    = []
        },
        {
          name              = "AWSManagedRulesAmazonIpReputationList"
          priority          = 20
          override_action   = "none"
          excluded_rules    = []
        },
                {
          name              = "AWSManagedRulesSQLiRuleSet"
          priority          = 30
          override_action   = "none"
          excluded_rules    = []
        },

        {
          name              = "AWSManagedRulesKnownBadInputsRuleSet"
          priority          = 40
          override_action   = "none"
          excluded_rules    = []
        },

        {
          name              = "AWSManagedRulesCommonRuleSet"
          priority          = 50
          override_action   = "none"
          excluded_rules    = []
        }
    ]
}

variable "http_headers_val_to_block" {
  description = "List of HTTP Headers value"
  type = list(string)
  default = ["jsp"]
}