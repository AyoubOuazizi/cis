provider "google" {
  credentials = file("../../Credentials/cis-key.json")
  project     = "cis-project-411615"
  region      = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "juice-shop-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "juice_shop_subnet" {
  name          = "juice-shop-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

resource "google_container_cluster" "gke_cluster" {
  name     = "owasp-juice-shop-cluster"
  location = "us-central1"
  initial_node_count = 1

  network       = google_compute_network.vpc_network.name
  subnetwork    = google_compute_subnetwork.juice_shop_subnet.name

  node_config {
    machine_type = "e2-standard-4"
    # image_type = "ubuntu_containerd"
    oauth_scopes = [
      # "https://www.googleapis.com/auth/compute",
      # "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes   = true 
    master_ipv4_cidr_block = "10.13.0.0/28"
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.7/32"
      display_name = "net1"
    }
  }
}

## Create jump host . We will allow this jump host to access GKE cluster. the ip of this jump host is already authorized to allowin the GKE cluster
resource "google_compute_address" "my_internal_ip_addr" {
  project      = "cis-project-411615"
  address_type = "INTERNAL"
  region       = "us-central1"
  subnetwork   = google_compute_subnetwork.juice_shop_subnet.name
  name         = "my-ip"
  address      = "10.0.0.7"
  description  = "An internal IP address for my jump host"
}

resource "google_compute_instance" "default" {
  project      = "cis-project-411615"
  zone         = "us-central1-a"
  name         = "jump-host"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.juice_shop_subnet.name
    network_ip = google_compute_address.my_internal_ip_addr.address
  }
  service_account {
    scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
  }
}

## Creare Firewall to access jump hist via iap
resource "google_compute_firewall" "rules" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

## Create IAP SSH permissions for your test instance
resource "google_project_iam_member" "project" {
  project = "cis-project-411615"
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:cis-project@cis-project-411615.iam.gserviceaccount.com"
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = "cis-project-411615"
  name    = "nat-router"
  network = google_compute_network.vpc_network.name
  region  = "us-central1"
}

## Create Nat Gateway with module
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = "cis-project-411615"
  region     = "us-central1"
  router     = google_compute_router.router.name
  name       = "nat-config"
}

# Création d'une règle de pare-feu
resource "google_compute_firewall" "allow_traffic" {
  name    = "allow-traffic"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]  # Autoriser tout le trafic
}

############Output############################################
output "kubernetes_cluster_host" {
  value       = google_container_cluster.gke_cluster.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.gke_cluster.name
  description = "GKE Cluster Name"
}