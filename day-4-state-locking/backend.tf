terraform {
  backend "s3" {
    bucket = "s3-lockfile.com"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}