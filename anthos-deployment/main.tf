resource "google_container_cluster" "primary" {
  provider = google-beta

  name                     = var.primary_name
  location                 = var.location

  release_channel {
    channel = var.release_channel
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    cloudrun_config {
      disabled = false

    }
  }

  node_pool {
    name       = var.node_name
    node_count = var.node_count

    node_config {
      preemptible  = var.preemptible
      machine_type = var.machine_type

      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
    }

    autoscaling {
      min_node_count = 1
      max_node_count = var.node_count * 2
    }
    version = var.node_version
  }
  min_master_version = var.min_master_version

  workload_identity_config {
    identity_namespace = "${data.google_project.project.project_id}.svc.id.goog"
  }

  depends_on = [google_project_service.container]

    lifecycle {
    ignore_changes = [
      resource_labels
    ]
  }
}

module "hub" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/hub"

  project_id       = var.default_project
  cluster_name     = var.primary_name
  location         = var.location
  cluster_endpoint = google_container_cluster.primary.endpoint
  gke_hub_sa_name  = format("%s-%s","gke-hub-sa",var.default_project)
  gke_hub_membership_name  = format("%s-%s","gke-hub-membership",var.default_project)
}

module "asm" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/asm"

  project_id       = var.default_project
  cluster_name     = var.primary_name
  location         = var.location
  cluster_endpoint = google_container_cluster.primary.endpoint
  asm_version      = var.asm_version
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

resource "null_resource" "wait" {
  depends_on = [module.acm.wait, module.asm.asm_wait, module.hub.wait]
}
