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
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.groups_attached](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | The groups of the user | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the user | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | The path of the user | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags of the user | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_user"></a> [user](#output\_user) | n/a |
<!-- END_TF_DOCS -->
