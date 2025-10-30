terraform {
  backend "s3" {
    bucket = "bbwfbakvihshihvskndvkhkj"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}