# AWS region
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "eu-west-1"
}
# AWS S3 bucket name
variable "aws_s3_bucket" {
  description = "AWS S3 bucket name for Terraform state storage"
  type        = string
  default     = "agent-pilot-terraform-state"
}
# AWS DynamoDB table name
variable "aws_dynamodb_table" {
  description = "AWS DynamoDB table name for Terraform state storage"
  type        = string
  default     = "terraform-DynamoDB"
}