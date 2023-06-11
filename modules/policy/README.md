<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.12.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the policy | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the policy | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | The path of the policy | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy of the policy | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags of the policy | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy"></a> [policy](#output\_policy) | n/a |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | n/a |
<!-- END_TF_DOCS -->
