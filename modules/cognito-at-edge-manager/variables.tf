# ----------------------------------------------------------------------------------------------------------------------
# Module
# ----------------------------------------------------------------------------------------------------------------------

variable "identifier" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "account_ids" {
  type = list(string)
  default = []
}

# ----------------------------------------------------------------------------------------------------------------------
# Cognito
# ----------------------------------------------------------------------------------------------------------------------

variable "cognito_groups" {
  type    = list(string)
  default = []
}

variable "cognito_urls" {
  type    = list(string)
  default = []
}

variable "cognito_callback_path" {
  type    = string
  default = "/auth-login"
}

variable "cognito_logout_path" {
  type    = string
  default = ""
}

variable "cognito_pool_deletion_protection" {
  type    = string
  default = "INACTIVE"
}

variable "cognito_logo_path" {
  type    = string
  default = "/assets/logo.png"
}

# ----------------------------------------------------------------------------------------------------------------------
