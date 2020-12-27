resource "google_compute_network" "default" {
  name    = "nw-for-k8s-cluster"
  project = var.project_id

  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name    = "sub-nw-for-k8s-cluster"
  project = var.project_id

  ip_cidr_range = "10.127.0.0/22"
  network       = google_compute_network.default.self_link

  region                   = var.region
  private_ip_google_access = true
}

