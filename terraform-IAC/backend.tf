terraform {
  backend "s3" {
    bucket = "vpc-ec2-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}