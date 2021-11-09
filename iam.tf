data "aws_iam_policy_document" "waf_logs_s3_policy" {
    statement {
        sid = "s3AllowRole"

        actions = [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
        ]
        resources = [
            aws_s3_bucket.waf_logs.arn,
            "${aws_s3_bucket.waf_logs.arn}/*"
        ]
    }
    statement {
      sid = "kinesisAllowRole"

      actions = [
          "logs:PutlogEvents"
      ]
      resources = [
          aws_cloudwatch_log_stream.waf_logs.arn
      ]
    }
}

data "aws_iam_policy_document" "assume_role_waf_logs" {
    statement {
        actions = ["sts:AssumeRole",]

        principals {
            type = "Service"
            identifiers = ["firehose.amazonaws.com"]

        }
    }
}

######################################
# kinesis policy to s3 buckets
######################################
resource "aws_iam_policy" "waf_logs_firehose_policy" {
    name = "AWSKinesisS3Policy"
    path = "/"
    policy = data.aws_iam_policy_document.waf_logs_s3_policy.json
}

######################################
# kinesis role to s3 buckets
######################################
resource "aws_iam_role" "waf_logs_firehose_role" {
    name = "waf-logs-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_waf_logs.json
    path = "/"
    force_detach_policies = true
}

resource "aws_iam_policy_attachment" "role-policy-attachment" {
    name = "policy-attachment"
    roles = [aws_iam_role.waf_logs_firehose_role.id]
    policy_arn = aws_iam_policy.waf_logs_firehose_policy.arn
}



