###################
# General Initialization
###################
terraform {
  required_version = ">= 1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25"
    }
  }
  backend "s3" {
    profile = "project-prd"
    bucket  = "project-prd-iac-state"
    key     = "terraform.prd.tfstate"
    region  = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = "${var.project}-${var.env}"
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
    }
  }
}
data "aws_caller_identity" "current" {}
