data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name        = var.cloudwatch_policy_name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        }
    ]
})
}

resource "aws_iam_policy" "s3_policy" {
  name        = var.s3_policy_name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                # "s3:ListBucket",
                # "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                # "s3:ListMultipartUploadParts",
                # "s3:AbortMultipartUpload",
                # "s3:GetObjectVersion",
                # "s3:DeleteObjectVersion",
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}",
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ]
        }
    ]
})
}

resource "aws_iam_policy" "ec2_policy" {
  name        = var.ec2_policy_name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeyPair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role" "iam_role" {
  name                = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  
  # Attach the policy
  inline_policy {
    name = aws_iam_policy.s3_policy.name
    policy = aws_iam_policy.s3_policy.policy
  }

  inline_policy {
    name = aws_iam_policy.ec2_policy.name
    policy = aws_iam_policy.ec2_policy.policy
  }

  inline_policy {
    name = aws_iam_policy.cloudwatch_policy.name
    policy = aws_iam_policy.cloudwatch_policy.policy
  }

}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${var.iam_role_name}_instance_profile"
  role = aws_iam_role.iam_role.name
}

# resource "aws_iam_access_key" "iam_access_key" {
#   user    = aws_iam_role.iam_role.name
#   pgp_key = var.pgp_key
# }