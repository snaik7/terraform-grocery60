provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "grocery60-terraform-state"
    key            = "${var.env}/services/grocery60/terraform.tfstate"
    region         = "us-east-2"
    # Replace this with your DynamoDB table name! not using
    #dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "grocery_web" {
  source = "../../../modules/services/grocery-web"
  env = "dev"
  instance_type = "t2.micro"
}