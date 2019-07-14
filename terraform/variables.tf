#
# Variables
#
variable "project" {
  default = "docker-239201"
}

variable "region" {
  default = "europe-west1"
}

variable "cluster_name" {
  default = "finalapp-cluster"
}

variable "cluster_zone" {
  default = "europe-west1-d"
}

variable "cluster_k8s_version" {
  default = "1.12.8-gke.10"
}

variable "initial_node_count" {
  default = 2
}

variable "autoscaling_min_node_count" {
  default = 2
}

variable "autoscaling_max_node_count" {
  default = 3
}

variable "disk_size_gb" {
  default = 20
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "is_preemptible" {
  default = "true"
}

#устаревшие права доступа
variable "legacy_abac" {
  default = "false"
}

variable "domain" {
  default = "weisdd.space."
}

variable "managed_zone" {
  default = "crawler"
}
