terraform {
  required_providers {
    aws = {
      source = "hasicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}
