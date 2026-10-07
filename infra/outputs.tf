output "alb_url" { value = "http://${aws_lb.alb.dns_name}" }
output "site_bucket" { value = aws_s3_bucket.site.id }
output "instance_id" { value = aws_instance.web.id }
