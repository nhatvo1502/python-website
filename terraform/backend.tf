terraform {
  backend "s3" {
    bucket = var.be_bucket_name
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
