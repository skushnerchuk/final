provider "kubernetes" {
  # Т.к. provider использует endpoint, актуальный на момент запуска terraform apply, обязательно нужно указывать host вручную, иначе будет обращение по некорректному IP-адресу (с прошлой сессии)
  host = "https://${google_container_cluster.cluster.endpoint}"
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }
}

provider "helm" {
  version         = "~> 0.9"
  install_tiller  = true
  service_account = "tiller"
  namespace       = "kube-system"
  kubernetes {
    # Т.к. provider использует endpoint, актуальный на момент запуска terraform apply, обязательно нужно указывать host вручную, иначе будет обращение по некорректному IP-адресу (с прошлой сессии)
    host = "https://${google_container_cluster.cluster.endpoint}"
  }
}

resource "google_compute_address" "lb" {
  name   = "lb"
  region = "${var.region}"
}

resource "helm_release" "nginx" {
  name  = "nginx"
  chart = "stable/nginx-ingress"

  set_string {
    name  = "controller.service.loadBalancerIP"
    value = "${google_compute_address.lb.address}"
  }

  # обе зависимости должны быть указаны, чтобы сперва удалялся nginx, а tiller - после
  depends_on = [kubernetes_cluster_role_binding.tiller, kubernetes_service_account.tiller]
}
