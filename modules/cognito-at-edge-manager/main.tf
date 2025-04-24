# ----------------------------------------------------------------------------------------------------------------------
# Cognito
# ----------------------------------------------------------------------------------------------------------------------

# Pool -----------------------------------------------------------------------------------------------------------------

resource "aws_cognito_user_pool" "this" {
  name                = var.identifier
  deletion_protection = var.cognito_pool_deletion_protection

  verification_message_template {
    email_message = "<p>Your reset code is {####}</p>"
    email_subject = "Cognito Password Reset"
    sms_message   = "{####}"
  }

  admin_create_user_config {
    allow_admin_create_user_only = true

    invite_message_template {
      email_message = "<p>Your credentials are:</p><p>Username: {username}</p><p>Temporary Password: {####}</p><p>Please login to any environment once and change your password within 7 days.</p>"
      email_subject = "Cognito Credentials"
      sms_message   = "{username}:{####}"
    }
  }

  tags = var.tags
}

# Client ---------------------------------------------------------------------------------------------------------------

resource "aws_cognito_user_pool_client" "this" {
  name         = var.identifier
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret         = true
  enable_token_revocation = true

  id_token_validity      = 24 # hours
  access_token_validity  = 24 # hours
  refresh_token_validity = 7  # days

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = [for url in var.cognito_urls : "https://${url}${var.cognito_callback_path}"]
  logout_urls                          = [for url in var.cognito_urls : "https://${url}${var.cognito_logout_path}"]
}

# UI Customization -----------------------------------------------------------------------------------------------------

resource "aws_cognito_user_pool_ui_customization" "this" {
  client_id    = aws_cognito_user_pool_client.this.id
  user_pool_id = aws_cognito_user_pool.this.id

  image_file = filebase64("${path.module}${var.cognito_logo_path}")
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.identifier
  user_pool_id = aws_cognito_user_pool.this.id
}

# User Groups ----------------------------------------------------------------------------------------------------------

resource "aws_cognito_user_group" "this" {
  for_each = toset(var.cognito_groups)

  user_pool_id = aws_cognito_user_pool.this.id
  name   = each.value
}

# Secrets Manager ------------------------------------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "this" {
  name       = "/cognito/${var.identifier}"
  kms_key_id = aws_kms_key.this.arn

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    client_id     = aws_cognito_user_pool_client.this.id
    client_secret = aws_cognito_user_pool_client.this.client_secret
    pool_id       = aws_cognito_user_pool.this.id
    ui_domain     = aws_cognito_user_pool_domain.this.domain
  })
}

resource "aws_secretsmanager_secret_policy" "this" {
  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = data.aws_iam_policy_document.secretsmanager.json
}

data "aws_iam_policy_document" "secretsmanager" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = [for id in var.account_ids : "arn:aws:iam::${id}:role/lambda-edge-execution-*"]
    }
  }
}

# KMS ------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  description         = "KMS key for ${var.identifier} cognito user pool"
  enable_key_rotation = true

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/cognito/${var.identifier}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "DefaultKMSKeyPolicy"
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }

    actions = ["kms:*"]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:DescribeKey"]
    resources = ["*"]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = [for id in var.account_ids : "arn:aws:iam::${id}:role/lambda-edge-execution-*"]
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
