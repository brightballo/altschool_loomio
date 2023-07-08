terraform {
  backend "s3" {
    bucket = "terraform-bk"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
