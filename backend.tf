terraform {
  backend "s3" {
    bucket         = "statefile-s3" # change this
    key            = "Gopiraju_S/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
