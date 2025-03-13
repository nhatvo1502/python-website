terraform {
  backend "s3" {
    bucket = "nnote-tfstate-031225"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}