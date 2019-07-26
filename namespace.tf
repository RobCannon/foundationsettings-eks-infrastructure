resource "kubernetes_namespace" "ns" {
  metadata {
    labels {
      app      = "${var.app}"
      env      = "${local.env}"
      team     = "${replace(var.team," ","_")}"
      customer = "${replace(var.customer," ","_")}"
    }

    name = "${var.app}-${local.env}"
  }
}
