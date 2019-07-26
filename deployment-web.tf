resource "kubernetes_deployment" "deployment-web" {
  metadata {
    name      = "${var.app}-web"
    namespace = "${kubernetes_namespace.ns.metadata.0.name}"
  }

  spec {
    replicas = 2

    # strategy = {
    #   type = "RollingUpdate"


    #   rolling_update = {
    #     max_surge       = 1
    #     max_unavailable = 1
    #   }
    # }

    min_ready_seconds = 5
    selector {
      match_labels {
        image_name = "${var.app}-web"
      }
    }
    template {
      metadata {
        labels {
          image_name = "${var.app}-web"
        }
      }

      spec {
        container {
          name              = "${var.app}-web"
          image             = "${var.container_registry}/${var.app}-web:${var.image_version}"
          image_pull_policy = "Always"

          port = [{
            name           = "http"
            container_port = 4200
          }]

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }

            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 4200
            }

            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 1
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service-web" {
  metadata {
    name      = "${var.app}-web"
    namespace = "${kubernetes_namespace.ns.metadata.0.name}"
  }

  spec {
    selector {
      image_name = "${var.app}-web"
    }

    port {
      port        = 80
      target_port = 4200
    }

    type = "NodePort"
  }
}
