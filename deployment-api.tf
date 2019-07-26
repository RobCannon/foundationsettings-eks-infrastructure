resource "kubernetes_deployment" "deployment-api" {
  metadata {
    name      = "${var.app}-api"
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
        image_name = "${var.app}-api"
      }
    }
    template {
      metadata {
        labels {
          image_name = "${var.app}-api"
        }
      }

      spec {
        container {
          name              = "${var.app}-api"
          image             = "${var.container_registry}/${var.app}-api:${var.image_version}"
          image_pull_policy = "Always"

          port = [{
            name           = "http"
            container_port = 3000
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
              path = "/api/health"
              port = 3000
            }

            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/api/health/ready"
              port = 3000
            }

            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 1
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service-api" {
  metadata {
    name      = "${var.app}-api"
    namespace = "${kubernetes_namespace.ns.metadata.0.name}"
  }

  spec {
    selector {
      image_name = "${var.app}-api"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "NodePort"
  }
}
