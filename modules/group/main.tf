terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }
  }
}

resource "aws_iam_group" "group" {
  name = var.name
  path = var.path
}

resource "aws_iam_group_policy_attachment" "policy_attachments" {
  count      = length(var.policies)
  group      = aws_iam_group.group.name
  policy_arn = var.policies[count.index]

  depends_on = [
    aws_iam_group.group,
  ]
}

#tfsec:ignore:aws-iam-no-policy-wildcards # Not applicable to MFA policy
resource "aws_iam_group_policy" "mfa" {
  group  = aws_iam_group.group.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*",
      "Condition": {
          "Bool": {
              "aws:MultiFactorAuthPresent": ["true"]
          }
      }
    }
  ]
}
EOF
}
