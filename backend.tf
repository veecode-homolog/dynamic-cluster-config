terraform {
  backend "s3" {
    bucket = "veecode-homolog-terraform-state"
    key    = "dynamic-cluster-config/persistent.tfstate"
    region = "us-east-1"
  }
}