provider "google" {
  # project = "qwiklabs-gcp-03-2aada7042ff3"
  project="qwiklabs-gcp-04-bca3b539409a"
  region  = "us-central1"
}

resource "google_storage_bucket" "static_site" {
  name                        = "my-static-terra-form-web-file-90909" # Must be globally unique
  location                    = "US"
  force_destroy               = true  
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "html_file" {
  name         = "index.html"
  bucket       = google_storage_bucket.static_site.name
  source       = "${path.module}/website/index.html"
  content_type = "text/html"
}

resource "google_storage_bucket_object" "error_page" {
  name         = "error.html"
  bucket       = google_storage_bucket.static_site.name
  source       = "${path.module}/website/error.html"
  content_type = "text/html"
}

resource "google_storage_bucket_object" "profile_image" {
  name         = "profile.png"
  bucket       = google_storage_bucket.static_site.name
  source       = "${path.module}/website/profile.png"
  content_type = "image/png"
}
