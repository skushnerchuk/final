resource "google_dns_record_set" "nginx" {
  name         = "nginx.${var.domain}"
  managed_zone = var.managed_zone
  type         = "A"
  ttl          = 60
  rrdatas      = ["${google_compute_address.lb.address}"]
}

resource "google_dns_record_set" "prometheus-server" {
  name         = "prometheus-server.${var.domain}"
  managed_zone = var.managed_zone
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${google_dns_record_set.nginx.name}"]
}

resource "google_dns_record_set" "grafana" {
  name         = "grafana.${var.domain}"
  managed_zone = var.managed_zone
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${google_dns_record_set.nginx.name}"]
}

resource "google_dns_record_set" "kibana" {
  name         = "kibana.${var.domain}"
  managed_zone = var.managed_zone
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${google_dns_record_set.nginx.name}"]
}
