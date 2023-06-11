terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
  alias  = "target"
}

###############################################################################
#
#  Test 1 - Create user with group and policy
#
###############################################################################
data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "test-policy" {
  source = "./modules/policy"

  name        = "test-policy-${random_string.test_run_id.result}"
  description = "test policy"
  path        = "/"
  tags        = {}

  policy = data.aws_iam_policy_document.example.json
}

#tfsec:ignore:aws-iam-enforce-mfa # Dummy policy used for demoing module
module "test-group" {
  source = "./modules/group"

  name     = "test-group-${random_string.test_run_id.result}"
  path     = "/"
  policies = [module.test-policy.policy_arn]
}

module "test-user" {
  source = "./modules/user"

  name   = "test-user-${random_string.test_run_id.result}"
  path   = "/"
  groups = [module.test-group.group.name]
  tags = {

  }
}


###############################################################################
#
#  Test 2 - Create user with group and policy, and create roles with
#           assume role policy
#
###############################################################################

data "aws_iam_policy_document" "example2" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role_dummy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [module.dummy_role.role_arn]
    }
  }
}

data "aws_iam_policy_document" "allow_assume_dummy_role" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = [module.dummy_role.role_arn]
  }
}

module "test-policy2" {
  source = "./modules/policy"

  name        = "test-policy2-${random_string.test_run_id.result}"
  description = "test policy2"
  path        = "/"
  tags        = {}

  policy = data.aws_iam_policy_document.allow_assume_dummy_role.json
}

#tfsec:ignore:aws-iam-enforce-mfa # Dummy policy used for demoing module
module "test-group2" {
  source = "./modules/group"

  name     = "test-group2-${random_string.test_run_id.result}"
  path     = "/test2/"
  policies = [module.test-policy2.policy_arn]
}

data "aws_iam_policy" "test_policy2_arn" {
  arn = module.test-policy2.policy_arn
  depends_on = [
    module.test-policy2
  ]
}

module "test-user2" {
  source = "./modules/user"

  name   = "test-user2-${random_string.test_run_id.result}"
  path   = "/test2/"
  groups = [module.test-group2.group.name]
  tags = {

  }
}

module "dummy_role" {
  source = "./modules/role"

  name        = "dummy-role-${random_string.test_run_id.result}"
  path        = "/"

  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
  EOT

  tags = {

  }
  policies = []
}

module "test-role2" {
  source = "./modules/role"

  name        = "test-role2-${random_string.test_run_id.result}"
  path        = "/"

  assume_role_policy = data.aws_iam_policy_document.assume_role_dummy.json

  tags = {

  }
  policies = [module.test-policy2.policy_arn]
}

resource "random_string" "test_run_id" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}
