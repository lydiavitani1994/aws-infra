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

data "template_file" "user_data" {
  template = <<EOF
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
    echo "PROFILE_NAME=${var.profile_name}" >> /etc/environment
    echo "AUTO_SCALING_GROUP_NAME=${var.aws_autoscaling_group_name}" >> /etc/environment
    sudo source /etc/environment
    
    EOF
}

# # echo "LAUNCH_TEMPLATE_ID=${aws_launch_template.launch_template.id}" >> /etc/environment
  #  
  #


data "aws_caller_identity" "current" {}

# output "account_id" {
#   value = data.aws_caller_identity.current.account_id
# }

resource "aws_kms_key" "ebs_kms_key" {
  description          = "ebs_kms_key"
  deletion_window_in_days = 10
  # key_usage            = "ENCRYPT_DECRYPT"
  # customer_master_key_spec = "RSA_2048"
  policy = jsonencode(
    {
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
})
}

resource "aws_launch_template" "launch_template" {
  image_id = data.aws_ami.aws_linux_2.id
  instance_type = var.instance_type
  key_name = var.key_name
  update_default_version = true
  # vpc_security_group_ids = [var.app_security_group_id]
  user_data = base64encode(data.template_file.user_data.rendered)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      encrypted = true
      kms_key_id = aws_kms_key.ebs_kms_key.arn
      delete_on_termination = var.delete_on_termination
      volume_size           = var.volume_size
      volume_type           = var.volume_type
    }
  }
  network_interfaces {  # AssociatePublicIpAddress
    associate_public_ip_address = var.associate_public_ip_address
    security_groups = [var.app_security_group_id]
    subnet_id                   = var.public_subnet_ids[0]
    delete_on_termination       = var.delete_on_termination 
  }
  iam_instance_profile { # IAM Role
    name = var.iam_instance_profile
  }
}

resource "aws_lb" "lb" {
  name = var.lb_name
  internal = false
  load_balancer_type = var.load_balancer_type

  subnets            = var.unique_public_subnet_id_az
  # subnets = local.unique_public_subnet_id_az
  security_groups    = [var.lb_security_group_id]
  
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = var.lb_target_group_name
  port     = var.app_port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    enabled = true
    path                = "/healthz"
    port                = var.app_port
    protocol            = var.protocol
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

data "aws_acm_certificate" "rsa_2048" {
  domain      = "${var.profile_name}.${var.domain}"
  key_types = ["RSA_2048"]
  most_recent = true
}

# resource "aws_lb_listener" "lb_listener_http" {
#   load_balancer_arn = aws_lb.lb.arn
#   port              = "80"
#   protocol          = var.protocol
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.lb_target_group.arn
#   }
# }

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.rsa_2048.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

# resource "aws_lb_listener_certificate" "lb_listener_certificate" {
#   listener_arn    = aws_lb_listener.lb_listener_https.arn
#   certificate_arn = data.aws_acm_certificate.rsa_2048.arn
# }


resource "aws_autoscaling_group" "asg" {

  name = var.aws_autoscaling_group_name
  max_size                  = 3
  min_size                  = 1
  desired_capacity = 1
  default_cooldown = 60
  vpc_zone_identifier       = var.public_subnet_ids
  tag {
    key = "Name"
    value = "WebApp"
    propagate_at_launch = true
  }

  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.lb_target_group.arn]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  adjustment_type        = var.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.asg.name
  scaling_adjustment = "1"
}

resource "aws_cloudwatch_metric_alarm" "max_usage_alarm" {
  alarm_name          = "max_usage_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = var.metric_name
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}


resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  adjustment_type        = var.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.asg.name
  scaling_adjustment = "-1"
}

resource "aws_cloudwatch_metric_alarm" "min_usage_alarm" {
  alarm_name          = "min_usage_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = var.metric_name
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 3

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}

data "aws_route53_zone" "route53_zone" {
  name         = "${var.profile_name}.${var.domain}."
  private_zone = var.private_zone
}

resource "aws_route53_record" "webapp" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "${data.aws_route53_zone.route53_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

