output "cognito_secret_arn" {
  value = aws_secretsmanager_secret_version.this.arn
}

output "cognito_key_arn" {
  value = aws_kms_key.this.arn
}
