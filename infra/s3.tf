# Bucket the pipeline uploads the built React site to

resource "aws_s3_bucket" "site" {
  bucket_prefix = "${var.project}-site-"
  force_destroy = true
}
