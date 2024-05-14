terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_config_files      = ["/Users/Kubuś/.aws/config"]
  shared_credentials_files = ["/Users/Kubuś/.aws/credentials"]
}
