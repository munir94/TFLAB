resource "kubernetes_secret" "basic_auth" {
  metadata {
    name      = "basic-auth"
    namespace =  kubernetes_namespace.kubecost.metadata[0].name
  }

  data = {
    auth = "Zm9vOiRhcHIxJE9GRzNYeWJwJGNrTDBGSERBa29YWUlsSDkuY3lzVDAK"
  }

  type = "Opaque"
}

resource "kubernetes_ingress_v1" "kubecost_ingress_tls01" {
  metadata {
    name = "kubecost-ingress-tls01"
    namespace = kubernetes_namespace.kubecost.metadata[0].name
    annotations = {
      "traefik.ingress.kubernetes.io/auth-realm" = "Authentication Required - kubecost"

      "traefik.ingress.kubernetes.io/auth-secret" = "basic-auth"

      "traefik.ingress.kubernetes.io/auth-type" = "basic"
    }
  }

  spec {
    ingress_class_name = "traefik"

    # tls {
    #   hosts       = ["kubecost.munirtajudin.xyz"]
    #   secret_name = "kubecost-tls"
    # }

    rule {
      #host = "cost-analyzer.local"
      host = "kubecost.munirtajudin.xyz"
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "kubecost-cost-analyzer"

              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}
# resource "kubernetes_ingress_v1" "kubecost_alb_ingress" {
#   metadata {
#     name = "kubecost-alb-ingress"

#     annotations = {
#     #   "alb.ingress.kubernetes.io/scheme" = "internet-facing"

#     #   "alb.ingress.kubernetes.io/target-type" = "ip"

#       "kubernetes.io/ingress.class" = "LoadBalancer"
#     }
#   }

#   spec {
#     rule {
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "kubecost-cost-analyzer"

#               port {
#                 number = 9090
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }


