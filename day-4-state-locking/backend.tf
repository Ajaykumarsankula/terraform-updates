terraform {
  backend "s3" {
    bucket = "s3-lockfile.com"
    key    = "terraform.tfstate"
    #use_lockfile = true #
    region = "us-east-1"
    dynamodb_table = "veera"
  }
}