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

# ---------------------------------------------
# Todo lo siguiente se comenta porque no lo necesitamos
# para acceso público sin restricciones de IP ni LB
# ---------------------------------------------

# resource "google_compute_security_policy" "armor_policy" {
#   project = var.project
#   name = "block-ip-policy"
#
#   rule {
#     action = "deny(403)"
#     description = "Restricted ip address"
#     priority = 1000
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = [var.ip_restriction]
#       }
#     }
#   }
#
#   rule {
#     action = "allow"
#     priority = 2147483647
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["*"]
#       }
#     }
#     description = "Default allow rule"
#   }
#
#   depends_on = [google_project_service.compute]
# }
#
# resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
#   name                  = "cloud-run-neg"
#   project               = var.project
#   region                = var.region
#   network_endpoint_type = "SERVERLESS"
#
#   cloud_run {
#     service = "simple-webapp-flask"
#   }
# }
#
# resource "google_compute_backend_service" "cloud_run_backend" {
#   name        = "cloud-run-backend"
#   project     = var.project
#   protocol    = "HTTP"
#   timeout_sec = 30
#
#   backend {
#     group = google_compute_region_network_endpoint_group.cloud_run_neg.id
#   }
#
#   security_policy = google_compute_security_policy.armor_policy.id
# }
#
# resource "google_compute_url_map" "lb_url_map" {
#   name            = "cloud-run-url-map"
#   default_service = google_compute_backend_service.cloud_run_backend.id
# }
#
# resource "google_compute_managed_ssl_certificate" "lb_ssl" {
#   name = "cloud-run-lb-cert"
#
#   managed {
#     domains = ["arav-el.one"]
#   }
# }
#
# resource "google_compute_target_https_proxy" "https_proxy" {
#   name            = "cloud-run-https-proxy"
#   url_map         = google_compute_url_map.lb_url_map.id
#   ssl_certificates = [google_compute_managed_ssl_certificate.lb_ssl.name]
# }
#
# resource "google_compute_global_address" "lb_ip" {
#   name    = "cloud-run-lb-ip"
#   project = var.project
# }
#
# resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
#   name        = "cloud-run-https-forwarding-rule"
#   target      = google_compute_target_https_proxy.https_proxy.id
#   port_range  = "443"
#   ip_protocol = "TCP"
#   ip_address  = google_compute_global_address.lb_ip.address
# }

# resource "google_cloudbuild_trigger" "github_push_trigger" {
#   project  = var.project
#   location = "global" 
#   name = "github-master-branch-push"
#   description = "Disparador automático que se ejecuta en cada 'push' a la rama principal."
#   filename = "../cloudbuild.yaml" 
#
#   github {
#     owner = var.github_repo_owner
#     name  = var.github_repo_name
#
#     push {
#       branch = "master" 
#     }
#   }
# }
