#
# Google Cloud Firewall
#
resource "google_compute_firewall" "k8s_firewall" {
  name    = "k8s-allow-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}
