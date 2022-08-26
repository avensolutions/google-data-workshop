provider "google" {
  project = var.project
  region  = var.region
}

resource "google_kms_key_ring" "env_keyring" {
  name     = "${var.environment}-${var.prefix}-keyring"
  location = var.region
}

resource "google_kms_crypto_key" "env_crypto_key" {
  name     = "${var.environment}-${var.prefix}-key"
  key_ring = google_kms_key_ring.env_keyring.id
}

resource "google_kms_key_ring" "us_keyring" {
  name     = "${var.environment}-${var.prefix}-us-keyring"
  location = var.key_region_us
}

resource "google_kms_crypto_key" "us_crypto_key" {
  name     = "${var.environment}-${var.prefix}-us-key"
  key_ring = google_kms_key_ring.us_keyring.id
}

resource "google_bigquery_dataset" "us_source_dataset" {
  dataset_id                  = "${var.environment}_${var.prefix}_source"
  friendly_name               = "${var.environment}_${var.prefix}_source"
  description                 = "This is my source tier dataset"
  location                    = var.region_us
}

resource "google_bigquery_dataset" "us_conformed_dataset" {
  dataset_id                  = "${var.environment}_${var.prefix}_conformed"
  friendly_name               = "${var.environment}_${var.prefix}_conformed"
  description                 = "This is my conformed tier dataset"
  location                    = var.region_us

/*
  default_encryption_configuration {
    kms_key_name = google_kms_crypto_key.us_crypto_key.id
  }
*/
}

resource "google_bigquery_dataset" "us_presentation_dataset" {
  dataset_id                  = "${var.environment}_${var.prefix}_presentation"
  friendly_name               = "${var.environment}_${var.prefix}_presentation"
  description                 = "This is my conformed tier dataset"
  location                    = var.region_us
/*
  default_encryption_configuration {
    kms_key_name = google_kms_crypto_key.us_crypto_key.id
  }
*/  
}

resource "google_bigquery_dataset_iam_binding" "reader" {
  dataset_id = google_bigquery_dataset.us_presentation_dataset.dataset_id
  role       = "roles/bigquery.dataViewer"

  members = [
    "user:javen@avensolutions.com",
  ]
}
