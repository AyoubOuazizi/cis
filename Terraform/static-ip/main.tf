provider "google" {
  credentials = file("../../Credentials/cis-key.json")
  project     = "cis-project-411615"
  region      = "us-central1"
}

resource "google_compute_address" "ingress_ip" {
  name   = "ingress-test-ip"
  region = "us-central1" 
  ip_version = "IPV4"
}

output "ip_address" {
  value = google_compute_address.ingress_ip.address
}
