variable "env" {
  description = "The name to use for environment"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "The region for web"
  type        = string
  default     = "us-east-2"
}