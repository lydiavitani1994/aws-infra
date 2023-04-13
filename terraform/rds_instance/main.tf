resource "aws_db_subnet_group" "private_subnet_group" {
  name       = var.private_subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = var.private_subnet_group_tag_name
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "rds_kms_key" {
  description          = "rds_kms_key"
  deletion_window_in_days = 10
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

resource "aws_db_instance" "db_instance" {
  allocated_storage = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  multi_az = var.multi_az
  identifier = var.identifier
  username             = var.username
  password             = var.password
  db_name              = var.db_name
  publicly_accessible = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.private_subnet_group.name
  parameter_group_name = var.parameter_group_name
  vpc_security_group_ids = ["${var.security_group_id}"]
  skip_final_snapshot  = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  apply_immediately = var.apply_immediately
  kms_key_id = aws_kms_key.rds_kms_key.arn
  storage_encrypted = true
  # final_snapshot_identifier = "test"
}
