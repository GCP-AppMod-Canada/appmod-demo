variable "primary_name" {
  type    = string
  default = "k8s-primary"
}

variable "location" {
  type    = string
  default = "us-central1"
}

variable "node_name" {
  type    = string
  default = "k8s-nodes"
}

variable "machine_type" {
  type    = string
  default = "e2-standard-4"
}

variable "default_project" {
  type    = string
}

variable "release_channel" {
  type    = string
  default = "STABLE"
}

variable "node_count" {
  type    = number
  default = 4
}

variable "preemptible" {
  type    = bool
  default = false
}

variable "sync_repo" {
  type    = string
}

variable "sync_branch" {
  type    = string
}

variable "policy_dir" {
  type    = string
}

variable "terraform_service_account" {
  type    = string
  default = "terraform@apt-rope-287612.iam.gserviceaccount.com"
}

variable "policy_controller" {
  type    = bool
  default = false
}

variable "install_template_library" {
  type    = bool
  default = false
}
