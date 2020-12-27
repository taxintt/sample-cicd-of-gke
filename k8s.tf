data "google_client_config" "current" {}


# generating a kubeconfig entry:
# gcloud container clusters get-credentials tf-gke --project <project_name>
resource "google_container_cluster" "primary"{
    name = "tf-gke"
    project = "${var.project_name}"
    location = "${var.zone}"

    remove_default_node_pool = true
    initial_node_count = 3
    min_master_version = "${var.node_version}"

    network = "nw-for-k8s-cluster"
    subnetwork = "sub-nw-for-k8s-cluster"

    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_versions
    # https://github.com/hashicorp/terraform-provider-google/issues/3966
    provider = "google-beta"

    addons_config {
      http_load_balancing {
        disabled = true
      }
      istio_config {
        disabled = false
      }
    }

    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#vpc-native-clusters
    ip_allocation_policy {
      cluster_ipv4_cidr_block  = "/16"
      services_ipv4_cidr_block = "/22"
    }

    depends_on = [
      google_service_account.least-privilege-sa-for-gke,
      google_compute_network.default,
    ]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool-for-tf-gke"
  cluster    = google_container_cluster.primary.name
  project = google_container_cluster.primary.project
  location   = google_container_cluster.primary.location

  node_count = 3

  # https://blog.yukirii.dev/create-gke-with-least-privilege-sa-using-terraform/
  node_config {
    preemptible  = true
    machine_type = "e2-small"
    service_account = "least-privilege-sa-for-gke@${var.project_name}.iam.gserviceaccount.com"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [
      google_service_account.least-privilege-sa-for-gke,
      google_compute_network.default,
    ]
}
