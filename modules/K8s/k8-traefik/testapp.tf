
# NGINX 1 Test Deployment
#
# TODO: Change your-domain according to your DNS record that you want to create
# TODO: Change your-zone-id according to your DNS zone ID in Cloudflare
# ---

resource "kubernetes_namespace" "nginx1" {

    metadata {
        name = "nginx1"
    }
}


resource "kubernetes_deployment" "nginx1" {

    depends_on = [
        kubernetes_namespace.nginx1
    ]

    metadata {
        name = "nginx1"
        namespace = "nginx1"
        labels = {
            app = "nginx1"
        }
    }

    spec {
        replicas = 1

        selector {
            match_labels = {
                app = "nginx1"
            }
        }

        template {
            metadata {
                labels = {
                    app = "nginx1"
                }
            }

            spec {
                container {
                    image = "nginxdemos/hello"
                    #image = "nginx:latest"
                    name  = "nginx"

                    port {
                        container_port = 80
                    }
                }
            }
        }
    }
}


resource "kubernetes_service" "nginx1" {

    depends_on = [
        kubernetes_namespace.nginx1
    ]

    metadata {
        name = "nginx1"
        namespace = "nginx1"
    }
    spec {
        selector = {
            app = "nginx1"
        }
        port {
            port = 80
        }

        type = "ClusterIP"
    }
}

resource "kubernetes_ingress_v1" "nginx1" {

    depends_on = [kubernetes_namespace.nginx1]

    metadata {
        name = "nginx1"
        namespace = "nginx1"
    }
    spec {
        rule {

            host = "nginx.munirtajudin.xyz"

            http {

                path {
                    path = "/"

                    backend {
                        service {
                            name = "nginx1"
                            port {
                                number = 80
                            }
                        }
                    }

                }
            }
        }
    }
}
