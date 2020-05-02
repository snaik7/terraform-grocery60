


Terraform has a built in command called terraform state which is used for advanced state management.
terraform state

terraform state list. This will give us a list of resources


Inspect the current state using 
terraform show.


command to see the execution plan before applying it.
terraform plan 

 This data is outputted when apply is called, and can be queried using the terraform output command.
 terraform output ip
	50.17.232.209

When using a new module for the first time, you must run either 
terraform init or terraform get to install the module

configuration is syntactically valid and internally consistent, the built in terraform validate 


command enables standardization which automatically updates configurations in the current directory for easy readability and consistency.
terraform fmt 

command downloads and installs providers used within the configuration
terraform init 



The prefix -/+ means that Terraform will destroy and recreate the resource, rather than updating it in-place

terraform destroy


Implicity Dependency 
resource "aws_instance" "example" {

}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}

Explicit Dependency 
# Change the aws_instance we declared earlier to now include "depends_on"
resource "aws_instance" "example" {
  # Tells Terraform that this EC2 instance must be created only after the
  # S3 bucket has been created.
  depends_on = [aws_s3_bucket.example]
}

Varibales 

variables.tf

variable "region" {
  default = "us-east-1"
}

Use variable 

provider "aws" {
  region = var.region
}

terraform apply -var 'region=us-east-1'

Using file name -terraform.tfvars
region = "us-east-1"

Using custom file name 
terraform apply -var-file="secret.tfvars" -var-file="production.tfvars"

Env Variable

TF_VAR_region variable can be set in the shell to set the region variable in Terraform.

backend config

-backend-config=PATH
-backend-config="KEY=VALUE"

terraform init -backend-config=backend.hcl


List

# Declare implicitly by using brackets []
variable "cidrs" { default = [] }

# Declare explicitly with 'list'
variable "cidrs" { type = list }

in tf.vars
cidrs = [ "10.0.0.0/16", "10.1.0.0/16" ]

Map

variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-4b32be2b"
  }
}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
}

in tf.vars
amis = {
  "us-east-1" = "ami-abc123"
  "us-west-2" = "ami-def456"
}

Output

output "ami" {
  value = aws_instance.example.ami
}

Provider naming

terraform-provider-<NAME>_vX.Y.Z,




Module Version -

module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.0.5"
  servers = 3
}

module requires particular versions of a specific provider, use a required_providers block inside a terraform block

module "aws_vpc" {
  source = "./aws_vpc"
  providers = {
    aws = aws.west
  }
}
resource requires particular versions of a specific provider
resource "aws_instance" "foo" {
  provider = aws.west
}

terraform {
  //required_version to ensure that the user deploying infrastructure is using Terraform 0.12 or great
  required_version = ">= 0.12"
  required_providers {
    aws = ">= 2.7.0"
  }
}
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"	

