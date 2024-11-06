# Specify the required Terraform version and providers
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Configure the Docker provider
provider "docker" {}

# Define a Docker image resource for Tomcat
resource "docker_image" "tomcat_image" {
  name         = "tomcat:latest"
  keep_locally = false
}

# Define a Docker container resource for Tomcat
resource "docker_container" "tomcat_container" {
  image = docker_image.tomcat_image.image_id
  name  = "tomcat_container"

  # Define container ports for Tomcat
  ports {
    internal = 8080
    external = 8096
  }
}

# Define a Docker image resource for Nginx
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# Define a Docker container resource for Nginx
resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.image_id
  name  = "nginx_container"

  # Define container ports for Nginx
  ports {
    internal = 80
    external = 8098
  }
}

