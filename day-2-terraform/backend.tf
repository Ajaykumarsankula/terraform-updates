terraform {
  backend "s3" {
    bucket = "bbwfbakvihshihvskndvkhkj"
    key    = "day-2-terraform.tfstate"
    region = "us-east-1"
  }
}