variable "project" {
  description = "The project ID to deploy to"
  type = string
}

variable "region" {
  description = "The region to deploy to"
  type = string
  default = "us-central1"
}

variable "ip_restriction" {
  description = "The IP address to block with Cloud Armor"
  type = string
}

variable "github_repo_owner" {
  description = "The owner of the GitHub repository (your GitHub username)"
  type = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository"
  type = string
}

variable "github_connection_name" {
  description = "The name of the 2nd gen Cloud Build connection to GitHub"
  type = string
}
