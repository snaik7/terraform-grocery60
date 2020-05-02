provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "grocery60" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.aws_sg_http.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
        sudo apt upgrade
        sudo apt install apache2
        sudo ufw allow 'Apache Full'
        sudo ufw status
              sudo systemctl status apache2
              sudo systemctl start apache2 &
              EOF
  tags = {
    Name = "grocery60"
  }
}

resource "aws_security_group" "aws_sg_http" {
  name = "xaws-sg-http"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "san-terraform-up-and-running-state"
    key            = "ws/terraform.tfstate"
    region         = "us-east-2"
    # Replace this with your DynamoDB table name! not using
    #dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
*/
resource "aws_s3_bucket" "terraform_state" {
  bucket = "san-terraform-up-and-running-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  region         = "us-east-2"
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

/*
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
*/







