terraform {
  backend "s3" {
    bucket = "nnote_tfstate_031225"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
