terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }
  }
}

resource "aws_iam_user" "user" {
  #checkov:skip=CKV_AWS_273:Will move to SSO in the future
  name = var.name
  path = var.path

  force_destroy = true

  tags = merge(
    { createdBy = "createdBy aws-iam/user" },
    var.tags
  )
}

resource "aws_iam_user_group_membership" "groups_attached" {
  user = aws_iam_user.user.name

  groups = var.groups
}
