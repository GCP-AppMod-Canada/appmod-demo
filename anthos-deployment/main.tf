resource "google_container_cluster" "primary" {
  provider = google-beta

  name                     = var.primary_name
  location                 = var.location
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = var.release_channel
  }

  depends_on = [google_project_service.container]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  provider = google-beta

  name       = var.node_name
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

module "hub" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/hub"

  project_id       = var.default_project
  cluster_name     = var.primary_name
  location         = var.location
  cluster_endpoint = google_container_cluster.primary.endpoint
}

module "asm" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/asm"

  project_id       = var.default_project
  cluster_name     = var.primary_name
  location         = var.location
  cluster_endpoint = google_container_cluster.primary.endpoint
}

module "acm" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/acm"

  project_id       = var.default_project
  cluster_name     = var.primary_name
  location         = var.location
  cluster_endpoint = google_container_cluster.primary.endpoint
  enable_policy_controller = var.policy_controller
  install_template_library = var.install_template_library
  sync_repo   = var.sync_repo
  sync_branch = var.sync_branch
  policy_dir  = var.policy_dir
}
