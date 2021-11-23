################################################################################################################
## create s3 bucket for static file
################################################################################################################

resource "aws_s3_bucket" "static_website" {
    bucket = "beno-project-12112021"
    acl    = "private"

    website {
        index_document = var.site-index
    }
    versioning {
        enabled = true
    }

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT", "POST", "GET"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000  #the time in seconds that the browser can cache the response for a preflight request 
    }
    tags = {
        "Automated" = "yes"
    }
}


################################################################################################################
## Upload S3 object for the static website
################################################################################################################
resource "aws_s3_bucket_object" "web_object" {
  for_each = fileset(path.module, "templates/*") #https://www.terraform.io/docs/language/meta-arguments/for_each.html
  bucket = aws_s3_bucket.static_website.id
  key    = each.value
  source = "${path.module}/${each.value}"
  content_type = "text/html" 
  etag = filemd5("${path.module}/${each.value}")
}

