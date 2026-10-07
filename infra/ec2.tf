# Web server (nginx); the pipeline copies the React build onto it

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    cat > /etc/nginx/conf.d/spa.conf <<'NGX'
    server {
      listen 80 default_server;
      root /usr/share/nginx/html;
      location / { try_files $uri /index.html; }
    }
    NGX
    systemctl enable --now nginx
  EOT

  tags = { Name = "${var.project}-web" }
}
