#-------------------> NAMESPACE RABBITMQ
resource "kubernetes_namespace" "namespace-rabbits" {
  metadata {
    name = "rabbits"
  }
}

#-----------------------------> CONFIGMAP RABBITMQ
resource "kubernetes_config_map" "configmap-rabbits" {
  depends_on = [
    kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name      = "rabbitmq-config"
    namespace = "rabbits"
  }

  data = {

    "enabled_plugins" = "[rabbitmq_federation,rabbitmq_management,rabbitmq_peer_discovery_k8s]."

    "rabbitmq.conf" = <<EOF
    loopback_users.guest = false
    listeners.tcp.default = 5672
    vm_memory_high_watermark.relative = 0.9

    cluster_formation.peer_discovery_backend  = rabbit_peer_discovery_k8s
    cluster_formation.k8s.host = kubernetes.default.svc.cluster.local
    cluster_formation.k8s.address_type = hostname
    cluster_formation.node_cleanup.only_log_warning = true
    ##cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
    ##cluster_formation.classic_config.nodes.1 = rabbit@rabbitmq-0.rabbitmq.rabbits.svc.cluster.local
    ##cluster_formation.classic_config.nodes.2 = rabbit@rabbitmq-1.rabbitmq.rabbits.svc.cluster.local
    EOF
  }
}

#-----------------------------> SECRETS RABBITMQ
resource "kubernetes_secret" "secrets-rabbits" {
  depends_on = [
    kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name      = "rabbitmq-secret"
    namespace = "rabbits"
  }

  data = {
    RABBITMQ_DEFAULT_ADMIN_LOGIN    = "guest"
    RABBITMQ_DEFAULT_ADMIN_PASSWORD = "guest"
    RABBITMQ_ERLANG_COOKIE          = "RU9KdmZFMURJOUVReHhlTEVuckY="
  }

  type = "Opaque"
}

#-----------------------------> SERVICE ACCOUNT RABBITMQ
resource "kubernetes_service_account" "service_account-rabbits" {
  depends_on = [
    kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name      = "rabbitmq-sa"
    namespace = "rabbits"
  }
}

#-----------------------------> ROLES RABBITMQ
resource "kubernetes_role" "roles-rabbits" {
  depends_on = [
    kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name      = "rabbitmq-role"
    namespace = "rabbits"
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list", "watch"]
  }
}

#-----------------------------> ROLE BINDINGS RABBITMQ 
resource "kubernetes_role_binding" "roles_bindings-rabbits" {
  depends_on = [
    kubernetes_role.roles-rabbits, kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name      = "rabbitmq-rb"
    namespace = "rabbits"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "rabbitmq-sa"
    namespace = "rabbits"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "rabbitmq-role"
  }
}

#-----------------------------> Persistent Volume RABBITMQ
resource "kubernetes_persistent_volume" "persistent_volume-rabbits" {
  depends_on = [
    azurerm_managed_disk.HD-PV-AKS, kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name = "data"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = azurerm_managed_disk.HD-PV-AKS.id
        disk_name     = "HD-PV-AKS"
        kind          = "Managed"
      }
    }
  }
}

#-----------------------------> STATEFULSET RABBITMQ
resource "kubernetes_stateful_set" "statefulset-rabbits" {
  depends_on = [
    kubernetes_namespace.namespace-rabbits, kubernetes_config_map.configmap-rabbits, kubernetes_secret.secrets-rabbits, kubernetes_service_account.service_account-rabbits,
    kubernetes_role_binding.roles_bindings-rabbits, kubernetes_persistent_volume.persistent_volume-rabbits
  ]

  metadata {
    name      = "rabbitmq"
    namespace = "rabbits"
  }

  spec {
    service_name = "rabbitmq"
    replicas     = 2

    selector {
      match_labels = {
        app = "rabbitmq"
      }
    }

    template {
      metadata {
        labels = {
          app = "rabbitmq"
        }
      }

      spec {
        service_account_name = "rabbitmq-sa"

        init_container {
          name              = "config"
          image             = "busybox:latest"
          image_pull_policy = "IfNotPresent"
          command           = ["/bin/sh", "-c", "cp /tmp/config/rabbitmq.conf /config/rabbitmq.conf && ls -l /config/ && cp /tmp/config/enabled_plugins /etc/rabbitmq/enabled_plugins"]

          volume_mount {
            name       = "config"
            mount_path = "/tmp/config/"
            read_only  = false
          }

          volume_mount {
            name       = "config-file"
            mount_path = "/config/"
          }

          volume_mount {
            name       = "plugins-file"
            mount_path = "/etc/rabbitmq/"
          }
        }

        container {
          name              = "rabbitmq"
          image             = "rabbitmq:3.8-management"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 4369
            name           = "discovery"
          }

          port {
            container_port = 5672
            name           = "amqp"
          }

          port {
            container_port = 15672
            name           = "amqp-external"
          }

          resources {
            requests = {
              cpu               = "250m"
              memory            = "256Mi"
              ephemeral-storage = "2Gi"
            }

            limits = {
              cpu               = "350m"
              memory            = "256Mi"
              ephemeral-storage = "4Gi"
            }
          }

          env {
            name = "RABBIT_POD_NAME"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }

          env {
            name = "RABBIT_POD_NAMESPACE"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          env {
            name = "RABBIT_POD_NAMESPACE"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          env {
            name  = "RABBITMQ_NODENAME"
            value = "rabbit@$(RABBIT_POD_NAME).rabbitmq.$(RABBIT_POD_NAMESPACE).svc.cluster.local"
          }

          env {
            name  = "RABBITMQ_USE_LONGNAME"
            value = "true"
          }

          env {
            name  = "K8S_HOSTNAME_SUFFIX"
            value = ".rabbitmq.$(RABBIT_POD_NAMESPACE).svc.cluster.local"
          }

          env {
            name  = "RABBITMQ_CONFIG_FILE"
            value = "/config/rabbitmq"
          }

          env {
            name = "RABBITMQ_DEFAULT_USER"
            value_from {
              secret_key_ref {
                name = "rabbitmq-secret"
                key  = "RABBITMQ_DEFAULT_ADMIN_LOGIN"
              }
            }
          }

          env {
            name = "RABBITMQ_DEFAULT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "rabbitmq-secret"
                key  = "RABBITMQ_DEFAULT_ADMIN_PASSWORD"
              }
            }
          }

          env {
            name = "RABBITMQ_ERLANG_COOKIE"
            value_from {
              secret_key_ref {
                name = "rabbitmq-secret"
                key  = "RABBITMQ_ERLANG_COOKIE"
              }
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/rabbitmq/"
            read_only  = false
          }

          volume_mount {
            name       = "config-file"
            mount_path = "/config/"
          }

          volume_mount {
            name       = "plugins-file"
            mount_path = "/etc/rabbitmq/"
            read_only  = false
          }

        }
        volume {
          name = "config-file"
        }

        volume {
          name = "plugins-file"
        }

        volume {
          name = "config"
          config_map {
            name = "rabbitmq-config"
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "500Mi"
          }
        }
      }
    }
  }
}

#-----------------------------> SERVICE RABBITMQ
resource "kubernetes_service" "service-rabbits" {
  depends_on = [
    kubernetes_stateful_set.statefulset-rabbits, kubernetes_namespace.namespace-rabbits
  ]
  metadata {
    name      = "rabbitmq"
    namespace = "rabbits"
  }
  spec {
    type = "ClusterIP"
    port {
      port        = 4369
      target_port = 4369
      name        = "discovery"
    }
    port {
      port        = 5672
      target_port = 5672
      name        = "amqp"
    }
    port {
      port        = 15672
      target_port = 15672
      name        = "amqp-external"
    }
    selector = {
      app = "rabbitmq"
    }
  }
}

