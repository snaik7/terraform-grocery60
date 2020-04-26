
resource "aws_instance" "grocery60" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "var.instance_type"
  vpc_security_group_ids = [aws_security_group.aws_sg_http.id]
  user_data              = <<-EOF
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

 /*             db_address="${data.terraform_remote_state.db.outputs.address}"
              db_port="${data.terraform_remote_state.db.outputs.port}"
              echo "Hello, World. DB is at $db_address:$db_port" >> indexdb.html
*/

resource "aws_security_group" "aws_sg_http" {
  name = "${var.env}-aws-sg-http"
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

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket  = "grocery60-terraform-state"
    key     = "dev/data-stores/postgres/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
/*
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "grocery60-terraform-state"
    key    = "${var.env}/data-stores/postgres/terraform.tfstate"
    region = "us-east-2"
  }
}
*/
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







