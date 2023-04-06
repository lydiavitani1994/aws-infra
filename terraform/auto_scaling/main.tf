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
    sudo source /etc/environment
    
    EOF
}


# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    #   -a fetch-config \
    #   -m ec2 \
    #   -c file:${var.cloudwatch_config_path} \
    #   -s

# Launch Configuration - launch template
resource "aws_launch_template" "launch_template" {
  image_id = data.aws_ami.aws_linux_2.id
  instance_type = "t2.micro"
  key_name = "ec2"
  # vpc_security_group_ids = [var.app_security_group_id]
  user_data = base64encode(data.template_file.user_data.rendered)
  network_interfaces {  # AssociatePublicIpAddress
    associate_public_ip_address = true
    security_groups = [var.app_security_group_id]
    subnet_id                   = var.public_subnet_ids[0]
    delete_on_termination       = true 
  }
  iam_instance_profile { # IAM Role
    name = var.iam_instance_profile
  }
}

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# data "aws_subnets" "filtered_public" {
#   for_each = toset(data.aws_availability_zones.available.zone_ids)

#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   filter {
#     name   = "tag:Name"
#     values = ["public*"]
#   }

#   filter {
#     name   = "availability-zone-id"
#     values = ["${each.value}"]
#   }
# }

# locals {
#   unique_public_subnet_id_az = [for k, v in data.aws_subnets.filtered_public : v.ids[0]]
# }


resource "aws_lb" "lb" {
  name = "csye6225-lb"
  internal = false
  load_balancer_type = "application"

  subnets            = var.unique_public_subnet_id_az
  # subnets = local.unique_public_subnet_id_az
  security_groups    = [var.lb_security_group_id]
  
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "tf-example-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    enabled = true
    path                = "/healthz"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}


resource "aws_autoscaling_group" "asg" {

  name = "csye6225-asg-spring2023"
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

# resource "aws_autoscaling_policy" "asg_cpu_policy" {
#   name = "csye6225-asg-cpu"
#   policy_type = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
#   adjustment_type = "ChangeInCapacity"
  
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = 2.0
#   }
# }

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  scaling_adjustment = "1"
}

resource "aws_cloudwatch_metric_alarm" "max_usage_alarm" {
  alarm_name          = "max_usage_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
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
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  scaling_adjustment = "-1"
}

resource "aws_cloudwatch_metric_alarm" "min_usage_alarm" {
  alarm_name          = "min_usage_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 2

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

