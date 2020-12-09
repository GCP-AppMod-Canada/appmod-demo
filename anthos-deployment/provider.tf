provider "google" {
  version = "~> 3.49.0"
  alias   = "tokengen"
}
data "google_client_config" "default" {
  provider = google.tokengen
}
data "google_service_account_access_token" "sa" {
  provider               = google.tokengen
  target_service_account = var.terraform_service_account
  lifetime               = "600s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

/******************************************
  GA Provider configuration
 *****************************************/
provider "google" {
  version = "~> 3.49.0"
  // access_token = data.google_service_account_access_token.sa.access_token
  project = var.default_project
}

/******************************************
  Beta Provider configuration
 *****************************************/
provider "google-beta" {
  version = "~> 3.49.0"
  // access_token = data.google_service_account_access_token.sa.access_token
  project = var.default_project
}


data "google_project" "project" {
}
