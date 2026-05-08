# staging/backend.tf
terraform {
  backend "s3" {
    bucket         = "terraform-state-shortener"
    key            = "staging/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}