data "aws_ami" "aws_linux_2" {
  most_recent = var.filter_most_recent

  filter {
    name   = "name"
    values = [var.filter_name_value]
  }

  filter {
    name   = "root-device-type"
    values = [var.filter_device_type_value]
  }

  filter {
    name   = "virtualization-type"
    values = [var.filter_virtualization_type_value]
  }
}

resource "aws_instance" "instance" {
  key_name = "ec2"
  ami           = data.aws_ami.aws_linux_2.id
  instance_type = var.instance_type
  disable_api_termination = var.disable_api_termination
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.public_subnet_ids[0]
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile = var.iam_instance_profile

  # root disk
  root_block_device {
    delete_on_termination = var.delete_on_termination
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

  user_data = <<-EOF
              #!/bin/bash
              chmod +x /etc/environment
              echo "#!/bin/sh" > /etc/environment
              echo "DB_USERNAME=${var.db_username}" >> /etc/environment
              echo "DB_PASSWORD=${var.db_password}" >> /etc/environment
              echo "DB_HOSTNAME=${var.db_hostname}" >> /etc/environment
              echo "S3_BUCKET_NAME=${var.s3_bucket_name}" >> /etc/environment
              echo "PROFILE_NAME=${var.iam_instance_profile}" >> /etc/environment
              echo "REGION=${var.region}" >> /etc/environment
              echo "CLOUDWATCH_NAMESPACE=${var.namespace}" >> /etc/environment
              sudo source /etc/environment

              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -c file:${var.cloudwatch_config_path} \
                -s
              
              EOF

#sudo touch /etc/start_cloudwatch
              # chmod -R 777 /etc/start_cloudwatch
              # echo "#!/bin/sh" > /etc/start_cloudwatch
              # echo "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
              #   -a fetch-config \
              #   -m ec2 \
              #   -c file:/opt/deployment/cloudwatch_config.json \
              #   -s" >> /etc/start_cloudwatch
              # sudo sh /etc/start_cloudwatch
# echo "S3_SECRET_ACCESS=${var.s3_secret_access}" >> /etc/environment
## sudo chmod o+x /var/log
              # sudo chmod -R 777 /var/log/webapp.log
              
  tags = {
    Name = var.tag_name
  }
}

# resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
#   name = var.cloudwatch_log_group_name
# }

# resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
#   name           = var.cloudwatch_log_stream_name
#   log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
# }

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id
}

data "aws_route53_zone" "route53_zone" {
  # provider = "aws.dns_zones"
  name         = "${var.profile_name}.${var.domain}."
  private_zone = var.private_zone
}

resource "aws_route53_record" "webapp" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "${data.aws_route53_zone.route53_zone.name}"
  type    = var.record_type
  ttl     = var.record_ttl
  records = ["${aws_eip.eip.public_ip}"]
}

# resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm" {
#   alarm_name                = var.alarm_name
#   comparison_operator       = var.comparison_operator
#   evaluation_periods        = var.evaluation_periods
#   metric_name               = var.metric_name
#   namespace                 = var.namespace
#   period                    = var.period
#   statistic                 = var.statistic
#   threshold                 = var.threshold
#   alarm_description         = var.alarm_description
#   insufficient_data_actions = []
# }

# resource "aws_cloudwatch_log_metric_filter" "cloudwatch_log_metric_filter" {
#   name           = "MyAppAccessCount"
#   pattern        = ""
#   log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name

#   metric_transformation {
#     name      = "EventCount"
#     namespace = "YourNamespace"
#     value     = "1"
#   }
# }
