variable "webacl_name" {
  type        = string
  default     = "WebACL"
  description = "Name of the Web ACL firewall"
}

variable "webacl_description" {
  type        = string
  default     = "WebACL"
  description = "Description for the Web ACL"
}

variable "scope" {
  type        = string
  default     = "REGIONAL"
  description = <<-EOD
  Whether for CloudFront distribution or for a regional application.
  Valid values are CLOUDFRONT or REGIONAL.
  To work with CloudFront, you must also specify the region us-east-1 on the AWS provider.
  EOD
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = ""
}

variable "vendor_name"{
  type = map 
  default = {
    vendor_name = "AWS"
  }

}

# variable "group_rules" {
#   type = list
#   default = [
#     {"rule_name": "AWS-AWSManagedRulesCommonRuleSet", "name" : "AWSManagedRulesCommonRuleSet", "priority": "0"},
#     {"rule_name": "AWS-AWSManagedRulesAmazonIpReputationList", "name" : "AWSManagedRulesAmazonIpReputationList", "priority" : "1"},
#     {"rule_name": "AWS-AWSManagedRulesKnownBadInputsRuleSet", "name" : "AWSManagedRulesKnownBadInputsRuleSet", "priority" : "2"},
#     {"rule_name": "AWS-AWSManagedRulesSQLiRuleSet", "name" : "AWSManagedRulesSQLiRuleSet", "priority" : "3"}
#     #{"rule_name": "AWS-AWSManagedRulesBotControlRuleSet", "name" : "AWSManagedRulesBotControlRuleSet", "priority" : "4"}, # 50 capacity # note you are charged additional fees when you use this rule
#   ]
# }

variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))
  description = "List of Managed WAF rules."
  default = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 20
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
    }
  ]
}

#cldfront vars
variable "site-index" {
   type = "string"
   description = "website index page"
   default = "sitemaintenance.html"
     
}

variable "s3_upload" {
  type = "list"
  description = "uploading multiple objects in s3"
  default = [
    {"key"  = "sitemaintenance.html", "content_type" = "text/html"},
    {"key"  = "nav_logo.png", "content_type" = "image/png"},
    {"key"  = "main.css", "content_type" = "text/css"},
    {"key"  = "vendor.js", "content_type" = "text/javascript"}
  ]
}

##################WHAT IS BOT##################################################################################
# Bot traffic describes any non-human traffic to a website or an app. 
#The term bot traffic often carries a negative connotation, but in reality bot traffic isn't necessarily good or bad
#AWS MAINTAINS A LIST OF BAD IPS AND WE CAN ACCESS IT THROUGH THERE MANAGED RULES




########### WEB ACL CAPACITY #######################
#Web ACL capacity – The maximum capacity for a web ACL is 1,500, 
#which is sufficient for most use cases. If you need more capacity, contact the AWS Support Center.


##################MEANING OF COUNT##################################################################################
#AWS WAF allows you to configure a “count” action for a Managed Rule, which counts the number of web requests that are 
#matched by the rules inside the Managed Rule. 
#You can look at the number of counted web requests to estimate how many of your web requests would be blocked if you enable the Managed Rule.