provider "google" {
  version = "3.51.0"
  project = "${var.project_id}"
  region  = "${var.region}"
}

provider "google-beta" {
  version = "3.51.0"
  project = "${var.project_id}"
  region  = "${var.region}"
}

provider "kubernetes" {
  # https://github.com/hashicorp/terraform-provider-kubernetes/releases
  version          = "1.13.3"
  project          = "${var.project_id}"
  load_config_file = false

  host  = "https://${data.google_container_cluster.primary.endpoint}"
  token = "${data.google_client_config.current.access_token}"

  # client_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
  # client_key = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}


