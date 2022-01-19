terraform {
  backend "s3" {
    bucket = "jamespetaldemo-terraform-state"
    key = "state/petal-api.tfstate"
    region = "us-east-1"
    profile = "petaldemo"
  }
}