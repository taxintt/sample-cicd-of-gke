resource "google_compute_network" "default" {
  name    = "nw-for-k8s-cluster"
  project = var.project_id

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "sub-nw-for-k8s-cluster"
  project                  = var.project_id
  region                   = var.region
  ip_cidr_range            = "10.2.0.0/16"
  
  network = google_compute_network.default.id
  private_ip_google_access = true
}

