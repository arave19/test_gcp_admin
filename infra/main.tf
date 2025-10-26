resource "google_project_service" "cloudbuild" {
  project = var.project
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = var.project
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "run" {
  project = var.project
  service = "run.googleapis.com"
}

resource "google_project_service" "compute" {
  project = var.project
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "docker_repo" {
  project = var.project
  location = var.region
  repository_id = "simple-webapp-flask-repo"
  format = "DOCKER"
  depends_on = [google_project_service.artifactregistry]
}

resource "google_compute_security_policy" "armor_policy" {
  project = var.project
  name = "block-ip-policy"
  rule {
    action = "deny(403)"
    description = "Restricted ip address"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [var.ip_restriction]
      }
    }
  }
  rule {
    action = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }
  depends_on = [google_project_service.compute]
}

resource "google_cloudbuild_trigger" "main_trigger" {
  project  = var.project
  name     = "bang-to-cloud-run-tf"
  location = "global"

  repository_event_config {
    repository = "projects/${var.project}/locations/global/connections/${var.github_connection_name}/repositories/${var.github_repo_owner}_${var.github_repo_name}"
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
  depends_on = [google_project_service.cloudbuild]
}
