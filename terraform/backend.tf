terraform {
	backend "s3" {
		bucket = var.be_bucket_name
	}
}