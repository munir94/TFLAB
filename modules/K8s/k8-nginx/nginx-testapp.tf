provider "kubernetes" {
    #load_config_file       = "false"
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}
  
  resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "${var.app}-deployment"

    labels = {
      app = var.app
    }
   
  }

  spec {
    replicas = var.replica

    selector {
      match_labels = {
        app = var.app
      }
    }

    template {
      metadata {
        labels = {
          app = var.app
        }
      }

      spec {
        container {
          name  = var.app-name
          image = var.image
        resources {
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          port {
            container_port = var.app-port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_svc" {
  metadata {
    name = "${var.app}-svc"

     annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = var.app-port
      target_port = var.app-tgport
    }

    selector = {
      app = var.app
    }
  }
}
# resource "kubernetes_ingress_v1" "app_ing" {
#   metadata {
#     name = "${var.app}-ing"

#     annotations = {
#       "kubernetes.io/ingress.class" = "azure/application-gateway"
#     }
#   }

#   spec {
#     rule {
#       host = "${var.app}.1xxx.com"

#       http {
#         path {
#           path = "/"

#           backend {
#             service_name = "${var.app}-svc"
#             service_port = var.app-tgport
#           }
#         }
#       }
#     }
#   }
# }

resource "kubernetes_ingress_v1" "app_ing" {

  

    metadata {
        name = "${var.app}-ing"
        #namespace = "nginx1"

        annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
    }

    spec {
        rule {

            host = "${var.app}.nginx.1xxx.com"

            http {

                path {
                    path = "/"

                    backend {
                        service {
                            name = "${var.app}-svc"
                            port {
                                number = var.app-tgport
                            }
                        }
                    }

                }
            }
        }
    }
}



