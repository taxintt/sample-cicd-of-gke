# https://istio.io/latest/docs/setup/platform-setup/gke/
resource "google_compute_firewall" "default" {
  name    = "fw-for-istio"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["10250", "443", "15017"]
  }

  # https://stackoverflow.com/questions/65297738/how-to-use-nodeport-in-custom-kubenetes-cluster-on-gcp
  source_tags = ["node"]
}