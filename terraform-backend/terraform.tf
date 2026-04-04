terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "5.78.0"
    }
  }
}

# AWS provider - Ireland region
provider "aws" {
  region = var.aws_region
}