# Terraform Configuration for Static Website on Google Cloud Storage 

This Terraform configuration creates a static website hosted on Google Cloud Storage. Below is a detailed explanation of each component.

## Code Structure Overview

The configuration consists of 5 main resources that work together to create and deploy a static website:

1. **Google Provider** - Connects to Google Cloud Platform
2. **Storage Bucket** - Creates the hosting container
3. **IAM Member** - Sets public access permissions
4. **HTML Files Upload** - Deploys website content
5. **Image Upload** - Deploys static assets

---

## Provider Configuration

```hcl
provider "google" {
  project = "qwiklabs-gcp-04-bca3b539409a"
  region  = "us-central1"
}
```

**Purpose**: Establishes connection to Google Cloud Platform

**Configuration Details**:
- `project`: Specifies the GCP project ID where resources will be created
- `region`: Sets the default region for resources (us-central1 = Iowa, USA)

**Note**: The commented line shows a previous project ID, indicating this configuration has been updated for a new GCP project.

---

## Storage Bucket Resource

```hcl
resource "google_storage_bucket" "static_site" {
  name                        = "my-static-terra-form-web-file-90909"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
  
  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }
}
```

**Purpose**: Creates the main storage container that will host the website files

**Configuration Breakdown**:

| Property | Value | Description |
|----------|-------|-------------|
| `name` | `"my-static-terra-form-web-file-90909"` | Globally unique bucket identifier |
| `location` | `"US"` | Multi-region location for better availability |
| `force_destroy` | `true` | Allows Terraform to delete bucket even with contents |
| `uniform_bucket_level_access` | `true` | Enables consistent IAM permissions across all objects |

**Website Configuration**:
- `main_page_suffix`: Default file served when accessing the root URL
- `not_found_page`: Custom 404 error page for non-existent paths

**Important**: Bucket names must be globally unique across all of Google Cloud Storage.

---

## Public Access Permission

```hcl
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
```

**Purpose**: Makes the bucket content publicly accessible on the internet

**Configuration Details**:
- `bucket`: References the bucket created above using Terraform interpolation
- `role`: `storage.objectViewer` allows read-only access to objects
- `member`: `allUsers` means anyone on the internet can access the files

**Security Note**: This configuration makes your website publicly accessible, which is required for a public website but should be used carefully.

---

## HTML Files Upload

### Index Page
```hcl
resource "google_storage_bucket_object" "html_file" {
  name         = "index.html"
  bucket       = google_storage_bucket.static_site.name
  source       = "${path.module}/website/index.html"
  content_type = "text/html"
}
```

### Error Page
```hcl
resource "google_storage_bucket_object" "error_page" {
  name         = "error.html"
  bucket       = google_storage_bucket.static_site.name
  source       = "${path.module}/website/error.html"
  content_type = "text/html"
}
```

**Purpose**: Uploads HTML files from local directory to the cloud storage bucket

**Configuration Details**:
- `name`: The file name as it will appear in the bucket
- `bucket`: References the bucket where the file will be stored
- `source`: Local file path using `path.module` for relative pathing
- `content_type`: Tells browsers how to handle the file (HTML in this case)

**File Structure Expected**:
```
project-root/
├── main.tf (this Terraform file)
└── website/
    ├── index.html
    └── error.html
```

---

## Image Asset Upload

```hcl
resource "google_storage_bucket_object" "profile_image" {
  name         = "profile.png"
  bucket       = google_storage_bucket.static_site.name
  source       = "${path.module}/website/profile.png"
  content_type = "image/png"
}
```

**Purpose**: Uploads image files that can be referenced in HTML

**Configuration Details**:
- `content_type`: Set to `image/png` for proper browser handling
- File must exist at `website/profile.png` relative to the Terraform file

---

## How It All Works Together

1. **Bucket Creation**: Terraform creates a storage bucket configured for website hosting
2. **Permission Setup**: Public read access is granted to make content accessible
3. **Content Upload**: HTML and image files are uploaded from local `website/` directory
4. **Website Activation**: The bucket serves `index.html` as the main page and `error.html` for 404 errors

## Deployment Commands

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy the website
terraform apply

# Access your website at:
# https://storage.googleapis.com/my-static-terra-form-web-file-90909/index.html
```

## Resource Dependencies

Terraform automatically handles the deployment order:
1. Storage bucket is created first
2. IAM permissions are applied to the bucket
3. Files are uploaded to the configured bucket

## Expected File Structure

Before running Terraform, ensure your project has this structure:

```
├── main.tf                    # This Terraform configuration
└── website/
    ├── index.html            # Main homepage
    ├── error.html            # 404 error page
    └── profile.png           # Image asset
```

The website will be accessible at: `https://storage.googleapis.com/my-static-terra-form-web-file-90909/index.html`




![Screenshot from 2025-05-22 14-29-18](https://github.com/user-attachments/assets/7411e0d1-0395-459c-8698-d0141924bfc1)


![Screenshot from 2025-05-22 14-29-54](https://github.com/user-attachments/assets/80e44d5c-ebdb-4ff5-885a-c34b4d425816)
