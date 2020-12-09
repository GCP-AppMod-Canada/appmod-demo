resource "google_project_service" "container" {
  project = var.default_project
  service = "container.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "gkeconnect" {
  project = var.default_project
  service = "gkeconnect.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "gkehub" {
  project = var.default_project
  service = "gkehub.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  project = var.default_project
  service = "cloudresourcemanager.googleapis.com"

  disable_on_destroy = false
}
