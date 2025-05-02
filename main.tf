module "app_full" {
  source = "git::git@github.com:Wingsuited123/master-app?ref=v1.0.0"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  # Module
  identifier = "master-thesis-full"
  tags = {
    Project = "Master Thesis"
  }

  # CloudFront
  cf_aliases             = ["valibaba.click"]
  cf_origin_id           = "S3"
  cf_default_root_object = "index.html"
  cf_price_class         = "PriceClass_100"
  cf_http_version        = "http2and3"
  cf_ipv6_enabled        = true

  cf_custom_error_responses = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]

  cf_restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["AT", "DE"]
    }
  }

  cf_cache_behavior_default = {
    target_origin_id       = "S3"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    lambda_functions = {
      viewer_request = {
        source_dir   = "${path.module}/lambda/redirect"
        include_body = true
        config_content = jsonencode({
          name       = "Dile"
          age        = 23
          city       = "Nis"
          occupation = "Frontend God"
          status     = "Single"
          certified  = "King"
        })
      }
      viewer_response = {
        handler    = "hello.test"
        source_dir = "${path.module}/lambda/viewer_response"
      },
      origin_request = {
        handler      = "index.func"
        source_dir   = "${path.module}/lambda/origin_request"
        include_body = true
      },
      origin_response = {
        handler    = "hello.handler"
        source_dir = "${path.module}/lambda/origin_response"
      }
    }
    cache_policy = {
      min_ttl     = 0
      max_ttl     = 31536000
      default_ttl = 86400
      parameters_in_cache_key_and_forwarded_to_origin = {
        cookies_config = {
          cookie_behavior = "whitelist"
          cookies = {
            items = ["cookie1", "cookie2"]
          }
        }
        headers_config = {
          header_behavior = "whitelist"
          headers = {
            items = ["header1", "header2"]
          }
        }
        query_strings_config = {
          query_string_behavior = "whitelist"
          query_strings = {
            items = ["query1", "query2"]
          }
        }
      }
    }
    origin_request_policy = {
      cookies_config = {
        cookie_behavior = "whitelist"
        cookies = {
          items = ["cookie1", "cookie2"]
        }
      }
      headers_config = {
        header_behavior = "whitelist"
        headers = {
          items = ["header1", "header2"]
        }
      }
      query_strings_config = {
        query_string_behavior = "whitelist"
        query_strings = {
          items = ["query1", "query2"]
        }
      }
    }
    response_headers_policy = {
      cors_config = {
        access_control_allow_credentials = true
        access_control_max_age_sec       = 3600
        origin_override                  = true
        access_control_allow_headers = {
          items = ["test"]
        }
        access_control_allow_methods = {
          items = ["GET"]
        }
        access_control_allow_origins = {
          items = ["test.example.comtest"]
        }
        access_control_expose_headers = {
          items = ["Header-Name"]
        }
      }
      custom_headers_config = {
        items = [
          {
            header   = "X-Test"
            override = true
            value    = "none"
          },
          {
            header   = "X-Permitted-Cross-Domain-Policies"
            override = true
            value    = "none"
          }
        ]
      }
      remove_headers_config = {
        items = [
          {
            header = "X-Powered-By"
          },
          {
            header = "X-Frame-Options"
          }
        ]
      }
      security_headers_config = {
        content_security_policy = {
          content_security_policy = "style-src 'self' 'unsafe-inline';"
          override                = true
        }
        content_type_options = {
          override = true
        }
        frame_options = {
          override     = true
          frame_option = "DENY"
        }
        referrer_policy = {
          referrer_policy = "same-origin"
          override        = true
        }
        strict_transport_security = {
          access_control_max_age_sec = 63072000
          include_subdomains         = true
          override                   = true
          preload                    = true
        }
        xss_protection = {
          mode_block = true
          protection = true
          override   = true
        }
      }
      server_timing_headers_config = {
        enabled       = true
        sampling_rate = 50
      }
    }
  }

  cf_cache_behaviors_ordered = [
    {
      target_origin_id       = "S3"
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      path_pattern           = "/dile/*"
      lambda_functions = {
        viewer_request = {
          source_dir   = "${path.module}/lambda/redirect"
          include_body = true
          file_content = jsonencode({
            name       = "Dile"
            age        = 23
            city       = "Nis"
            occupation = "Frontend God"
            status     = "Single"
            certified  = "King"
          })
        },
        viewer_response = {
          handler              = "hello.test"
          source_dir           = "${path.module}/lambda/viewer_response"
          install_dependencies = true
        },
        origin_request = {
          handler              = "index.func"
          source_dir           = "${path.module}/lambda/origin_request"
          include_body         = true
          install_dependencies = true
        },
        origin_response = {
          handler              = "hello.handler"
          source_dir           = "${path.module}/lambda/origin_response"
          install_dependencies = true
        }
      }
      cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
      origin_request_policy_id   = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # CORS-S3Origin
      response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c" # SimpleCORS
    }
  ]

  # Cognito
  cognito_auth_enabled = true
  cognito_groups       = ["administrators", "developers"]
  cognito_whitelist    = ["127.0.0.1/32"]
  cognito_secret_arn   = module.manager.cognito_secret_arn
  cognito_key_arn      = module.manager.cognito_key_arn

  # Lambda
  lambda_deployment_bash_interpreter = ["C:/Program Files/Git/bin/bash.exe", "-lc"]
  lambda_deployment_npm_path         = "/c/Program Files/nodejs/npm"

  # S3
  s3_bucket_name            = "vs-master-thesis-full"
  s3_kms_encryption_enabled = true
  s3_versioning_enabled     = true
  s3_lifecycle_enabled      = true

  # ACM
  acm_certificate_arn = "arn:aws:acm:us-east-1:294556365148:certificate/c25d9178-9d4d-4347-93e9-a0b5d4e3a8dd"
}

module "app_minimal" {
  source = "git::git@github.com:Wingsuited123/master-app?ref=v1.0.0"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  # Module
  identifier = "master-thesis-minimal"

  # CloudFront
  cf_aliases = ["minimal.valibaba.click"]

  # Cognito
  cognito_auth_enabled = true
  cognito_secret_arn   = module.manager.cognito_secret_arn
  cognito_key_arn      = module.manager.cognito_key_arn

  # Lambda
  lambda_deployment_bash_interpreter = ["C:/Program Files/Git/bin/bash.exe", "-c"]
  lambda_deployment_npm_path         = "/c/Program Files/nodejs/npm"

  # S3
  s3_bucket_name = "vs-master-thesis-minimal"
}

module "app_disabled" {
  source = "git::git@github.com:Wingsuited123/master-app?ref=v1.0.0"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  # Module
  identifier = "master-thesis-disabled"

  # CloudFront
  cf_aliases = ["disabled.valibaba.click"]

  # Lambda
  lambda_deployment_bash_interpreter = ["C:/Program Files/Git/bin/bash.exe", "-c"]
  lambda_deployment_npm_path         = "/c/Program Files/nodejs/npm"

  # S3
  s3_bucket_name = "vs-master-thesis-disabled"
}

module "manager" {
  source = "git::git@github.com:Wingsuited123/master-manager?ref=v1.0.0"

  identifier  = "master-thesis-manager"
  account_ids = ["294556365148"]

  cognito_groups = ["administrators", "developers", "testers"]
  cognito_urls   = ["valibaba.click", "minimal.valibaba.click", "disabled.valibaba.click"]
}
