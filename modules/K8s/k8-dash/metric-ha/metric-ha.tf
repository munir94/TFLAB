resource "kubernetes_service_account" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"

    labels = {
      k8s-app = "metrics-server"
    }
  }
}

resource "kubernetes_cluster_role" "system_aggregated_metrics_reader" {
  metadata {
    name = "system:aggregated-metrics-reader"

    labels = {
      k8s-app = "metrics-server"

      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"

      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"

      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
  }
}

resource "kubernetes_cluster_role" "system_metrics_server" {
  metadata {
    name = "system:metrics-server"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["nodes/metrics"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods", "nodes"]
  }
}

resource "kubernetes_role_binding" "metrics_server_auth_reader" {
  metadata {
    name      = "metrics-server-auth-reader"
    namespace = "kube-system"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
}

resource "kubernetes_cluster_role_binding" "metrics_server_system_auth_delegator" {
  metadata {
    name = "metrics-server:system:auth-delegator"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
}

resource "kubernetes_cluster_role_binding" "system_metrics_server" {
  metadata {
    name = "system:metrics-server"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:metrics-server"
  }
}

resource "kubernetes_service" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  spec {
    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "https"
    }

    selector = {
      k8s-app = "metrics-server"
    }
  }
}

resource "kubernetes_deployment" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        k8s-app = "metrics-server"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "metrics-server"
        }
      }

      spec {
        volume {
          name      = "tmp-dir"
          empty_dir  {}
        }

        container {
          name  = "metrics-server"
          image = "k8s.gcr.io/metrics-server/metrics-server:v0.6.1"
          args  = ["--cert-dir=/tmp", "--secure-port=4443", "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname", "--kubelet-use-node-status-port", "--metric-resolution=15s"]

          port {
            name           = "https"
            container_port = 4443
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu = "100m"

              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "tmp-dir"
            mount_path = "/tmp"
          }

          liveness_probe {
            http_get {
              path   = "/livez"
              port   = "https"
              scheme = "HTTPS"
            }

            period_seconds    = 10
            failure_threshold = 3
          }

          readiness_probe {
            http_get {
              path   = "/readyz"
              port   = "https"
              scheme = "HTTPS"
            }

            initial_delay_seconds = 20
            period_seconds        = 10
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user               = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "metrics-server"

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  k8s-app = "metrics-server"
                }
              }

              namespaces   = ["kube-system"]
              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        priority_class_name = "system-cluster-critical"
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }
  }
}

resource "kubernetes_pod_disruption_budget" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
  }

  spec {
    min_available = "1"

    selector {
      match_labels = {
        k8s-app = "metrics-server"
      }
    }
  }
}

resource "kubernetes_api_service" "v1beta1metricsk8sio" {
  metadata {
    name = "v1beta1.metrics.k8s.io"

    labels = {
      k8s-app = "metrics-server"
    }
  }

  spec {
    service {
      namespace = "kube-system"
      name      = "metrics-server"
    }

    group                    = "metrics.k8s.io"
    version                  = "v1beta1"
    insecure_skip_tls_verify = true
    group_priority_minimum   = 100
    version_priority         = 100
  }
}

