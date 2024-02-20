terraform {
  backend "s3" {
    bucket = "terraform-kiru-s3-backend-demo"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-s3-backend-demo"
  }
}
