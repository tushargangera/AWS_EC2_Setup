terraform {
  backend "s3" {
    bucket = "infra-terraform-av-remote-backend"
    key = "state-files"
    region = "us-east-2"
  }
}

output "success_message" {
  value = "!!!the terraform s3 backend has been succesfully created!!!"
}

output "tf_state_files" {
  value = "!!!the terraform tf.lock files will now be stored in the remote backend!!!"
}