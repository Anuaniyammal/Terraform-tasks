terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "random" {
  # Configuration options
}

resource "random_bytes" "secret" {
  length = var.prompt
  # Interactive mode
}

output "random_bytes" {
  value = random_bytes.secret.base64
  sensitive = true
}

resource "random_id" "server" {
  byte_length = var.envv
  # call using environment variables
}

output "random_id" {
  value = random_id.server.id
}

resource "random_integer" "priority" {
  min = 1
  max = 50000
  #using default value
}

output "random_number" {
  value = random_integer.priority.result
}

resource "random_password" "password" {
  length           = var.length1
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  #using terraform.vars file
}
output "random_password" {
  value     = random_password.password.result
  sensitive = true
}

resource "random_shuffle" "az" {
  input        = ["us-west-1a", "us-west-1c", "us-west-1d", "us-west-1e"]
  result_count = var.counts
  #using auto.tfavrs file
}

output "random_shuffle" {
  value = random_shuffle.az.result
}

resource "random_string" "random" {
  length           = var.say
  special          = true
  override_special = "/@£$"
 #inline injection
}

output "random_name" {
  value = random_string.random.result
}






