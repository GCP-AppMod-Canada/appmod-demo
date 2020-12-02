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
  default = "apt-rope-287612"
}

variable "release_channel" {
  type    = string
  default = "STABLE"
}
