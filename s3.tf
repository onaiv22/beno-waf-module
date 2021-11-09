###########################################
# s3 bucket for waf logs
###########################################
resource "aws_s3_bucket" "waf_logs" {
    bucket = "waf-logs-08112021"
    acl = "private"

    tags = {
        "Automated" = "yes" 
    }
}

resource "aws_s3_bucket_public_access_block" "no_public_source" {
    bucket = aws_s3_bucket.waf_logs.id 

    block_public_acls       = true 
    block_public_policy     = true
    restrict_public_buckets = true 
    ignore_public_acls      = true
}
