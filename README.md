# terraform-aws-iam
terraform module to manage aws iam

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dummy_role"></a> [dummy\_role](#module\_dummy\_role) | ./modules/role | n/a |
| <a name="module_test-group"></a> [test-group](#module\_test-group) | ./modules/group | n/a |
| <a name="module_test-group2"></a> [test-group2](#module\_test-group2) | ./modules/group | n/a |
| <a name="module_test-policy"></a> [test-policy](#module\_test-policy) | ./modules/policy | n/a |
| <a name="module_test-policy2"></a> [test-policy2](#module\_test-policy2) | ./modules/policy | n/a |
| <a name="module_test-role2"></a> [test-role2](#module\_test-role2) | ./modules/role | n/a |
| <a name="module_test-user"></a> [test-user](#module\_test-user) | ./modules/user | n/a |
| <a name="module_test-user2"></a> [test-user2](#module\_test-user2) | ./modules/user | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.test_run_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy.test_policy2_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.allow_assume_dummy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_dummy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.example2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_test_run_id"></a> [test\_run\_id](#output\_test\_run\_id) | ID of this test run. Generated for every test run. |
<!-- END_TF_DOCS -->