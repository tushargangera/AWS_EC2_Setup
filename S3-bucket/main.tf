provider "aws" {
  region = "us-east-2"
}

variable "bucket_name" {
  default = "infra-terraform-av-remote-backend"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
}

output "success_message" {
  value = "S3 bucket ${var.bucket_name} has been succesfully created!!"
}