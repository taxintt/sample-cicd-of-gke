# https://istio.io/latest/docs/setup/platform-setup/gke/
resource "google_compute_firewall" "rule-for-istio" {
  name    = "allow-connections-for-istio"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["10250", "443", "15017"]
  }

  # https://stackoverflow.com/questions/65297738/how-to-use-nodeport-in-custom-kubenetes-cluster-on-gcp
  target_tags = ["istio"]
}

resource "google_compute_firewall" "rule-for-iap" {
  name    = "allow-iap-forwarding-ssh"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}