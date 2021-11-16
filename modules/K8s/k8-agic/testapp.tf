provider "kubernetes" {
    #load_config_file       = "false"
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}
  

resource "kubernetes_deployment" "httpd_deployment" {
  metadata {
    name = "httpd-deployment"

    labels = {
      app = "httpd"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "httpd"
      }
    }

    template {
      metadata {
        labels = {
          app = "httpd"
        }
      }

      spec {
        container {
          name  = "httpd"
          image = "httpd"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "httpd_svc" {
  metadata {
    name = "httpd-svc"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    selector = {
      app = "httpd"
    }
  }
}

resource "kubernetes_ingress" "httpd_ing" {
  metadata {
    name = "httpd-ing"

    annotations = {
      "kubernetes.io/ingress.class" = "azure/application-gateway"
    }
  }

  spec {
    rule {
      host = "httpd.xxx.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "httpd-svc"
            service_port = "80"
          }
        }
      }
    }
  }
}

