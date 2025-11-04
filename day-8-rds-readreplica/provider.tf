provider "aws" {
  region = "us-east-1"  # Primary DB region
  alias  = "primary"
}

provider "aws" {
  region = "us-west-2"  # Replica region
  alias  = "replica"
}