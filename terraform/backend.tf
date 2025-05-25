terraform {
  backend "s3" {
    bucket         = "dobsonddev-portfolio-api-terraform-state"
    key            = "portfolio-api/terraform.tfstate"
    region         = "us-east-1"
    profile        = "dobson-personal-aws"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}