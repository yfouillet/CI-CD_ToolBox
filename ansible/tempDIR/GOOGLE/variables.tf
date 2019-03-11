
aws_bucket_tfstate = "test"
aws_region_tfstate = "us-east"
aws_bucketkey_tfstate = "Master-terraform/terraform.tfstate"

google_credentials = "${file("google_account.json")}"
google_project     = "test"
google_region      = "test"