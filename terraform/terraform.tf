terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }

  backend "s3" {
    bucket         = "agent-pilot-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-DynamoDB"
  }
}

# AWS provider - Ireland region
provider "aws" {
  region = var.aws_region
}