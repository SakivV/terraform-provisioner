terraform {
  required_version = "~>1.3.6"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>4.45.0"
    }
  }
  backend "s3" {
    bucket = "terrafrom-state-bucket-20230118"
    key = "provisioner/terraform.tfstate"
    dynamodb_table = "aws_terraform_lock"
    region = "us-east-1"
  }

}

provider "aws" {
  region = var.aws_region
}