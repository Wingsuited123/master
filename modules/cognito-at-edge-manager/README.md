<!-- BEGIN_TF_DOCS -->
# Cognito at Edge Cognito Module

Terraform module which creates AWS resources that provision a Cognito User Pool & Client to use with the Cognito at Edge CloudFront module.

## Usage

### Minimal deployment
```hcl
module "cognito_at_edge_manager" {
  source = "./modules/cognito-at-edge-manager"
  # Module
  identifier  = "cognito-at-edge-manager"
  account_ids = ["123456789012"]
  # Cognito
  cognito_urls = ["<list-of-domains-that-are-passed-to-app-module-as-aliases>"]
}
```

### Full deployment
```hcl
module "cognito_at_edge_manager" {
  source = "./modules/cognito-at-edge-manager"
  # Module
  identifier  = "cognito-at-edge-manager"
  tags        = { Project = "Cognito at Edge" }
  account_ids = ["123456789012"]
  # Cognito
  cognito_groups                   = ["administrators", "developers", "testers"]
  cognito_urls                     = "<list-of-domains-that-are-passed-to-app-module-as-aliases>"
  cognito_callback_path            = "/your-custom-callback-path"
  cognito_logout_path              = "/your-custom-logout-path"
  cognito_pool_deletion_protection = true
  cognito_logo_path                = "/your-custom-logo-path"
}
```
      

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cognito_user_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group) | resource |
| [aws_cognito_user_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_cognito_user_pool_ui_customization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_cognito_callback_path"></a> [cognito\_callback\_path](#input\_cognito\_callback\_path) | n/a | `string` | `"/auth-login"` | no |
| <a name="input_cognito_groups"></a> [cognito\_groups](#input\_cognito\_groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_cognito_logo_path"></a> [cognito\_logo\_path](#input\_cognito\_logo\_path) | n/a | `string` | `"/assets/logo.png"` | no |
| <a name="input_cognito_logout_path"></a> [cognito\_logout\_path](#input\_cognito\_logout\_path) | n/a | `string` | `""` | no |
| <a name="input_cognito_pool_deletion_protection"></a> [cognito\_pool\_deletion\_protection](#input\_cognito\_pool\_deletion\_protection) | n/a | `string` | `"INACTIVE"` | no |
| <a name="input_cognito_urls"></a> [cognito\_urls](#input\_cognito\_urls) | n/a | `list(string)` | `[]` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cognito_key_arn"></a> [cognito\_key\_arn](#output\_cognito\_key\_arn) | n/a |
| <a name="output_cognito_secret_arn"></a> [cognito\_secret\_arn](#output\_cognito\_secret\_arn) | n/a |
<!-- END_TF_DOCS -->