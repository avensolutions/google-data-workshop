terraform {
  backend "gcs" {
    bucket  = "tf-state-6x3ctx9vj9"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "raw_data" {
  name          = var.data_bucket
  location      = var.region
}

resource "google_composer_environment" "composer" {
  name   = "my-composer-env"
  region = var.region
 config {
    software_config {
      image_version = "composer-1-airflow-2"
    }
  }
}