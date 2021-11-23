################################################################################################################
## origin access identity
################################################################################################################
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "Cloudfront access to s3 bucket"
}

data "aws_iam_policy_document" "s3_policy" {
    statement {
        actions = [
            "s3:GetObject",
            "s3:ListBucket",
            ]
        resources = [
            "${aws_s3_bucket.static_website.arn}/*",
            aws_s3_bucket.static_website.arn,
            ]

        principals {
            type = "AWS"
            identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
        }
    }
}

resource "aws_s3_bucket_policy" "static_website" {
    bucket = aws_s3_bucket.static_website.id
    policy = data.aws_iam_policy_document.s3_policy.json
    
}
