resource "aws_cloudfront_distribution" "web" {
    origin {
        domain_name                = aws_s3_bucket.static_website.bucket_regional_domain_name
        origin_id                  = "origin-bucket-${aws_s3_bucket.static_website.id}"
        origin_path                = "/templates"

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
        }
    }
    enabled                        = true 
    is_ipv6_enabled                = true 
    comment                        = "cloudfront distribution for maintenance page"
    default_root_object            = var.site-index

    #aliases = [list of alternative domain names for the distribution] 

    default_cache_behavior {
        allowed_methods           = ["GET", "HEAD"]
        cached_methods            = ["GET", "HEAD"]
        target_origin_id          = "origin-bucket-${aws_s3_bucket.static_website.id}"

        forwarded_values {
            query_string          = false

            cookies {
                forward           = "none"
            }
        }

        viewer_protocol_policy    = "allow-all"
        compress                  = true
        min_ttl                   = "0"
        default_ttl               = "3600"
        max_ttl                   = "84600"
    }

    price_class                   = "PriceClass_200"
    
    restrictions {
        geo_restriction {
            restriction_type      = "none"
        }
    }

    tags = {
        "Automated" = "yes"
    }
    viewer_certificate {
        cloudfront_default_certificate = true
        ssl_support_method        = "sni-only"
        minimum_protocol_version = "TLSv1.2_2019"
    }
}