terraform {
  required_version = ">=1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  #profile = "profile_name"
}

# resource "<provider>_<resource_type>" "name" {
#   config options
#   key = "value"
#   key2 = "another value"
# }
