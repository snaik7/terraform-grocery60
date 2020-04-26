provider "aws" {
  region = "us-east-2"
}
resource "aws_db_instance" "postgres_database" {
  identifier_prefix   = "postgres_grocery60"
  engine              = "postgres"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "grocery60"
  username            = "postgres"
  password            = "pakistan"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "grocery60-terraform-state"
    key            = "dev/data-stores/postgres/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}