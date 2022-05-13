#-----------------------------> INGRESS AKS-FITVERSE
resource "kubernetes_ingress" "ingress-fitverse" {
  metadata {
    name = "ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    tls {
      hosts       = ["fitverse.pl"]
      secret_name = "fitverse-secret-tls"
    }
    rule {
      host = "fitverse.pl"
      http {
        path {
          path = "/api/ms"
          backend {
            service_name = "ms-service"
            service_port = 83
          }
        }

        path {
          path = "/api/as"
          backend {
            service_name = "as-service"
            service_port = 85
          }
        }

        path {
          path = "/api/cs"
          backend {
            service_name = "cs-service"
            service_port = 87
          }
        }

        path {
          path = "/api/auth"
          backend {
            service_name = "auth-service"
            service_port = 89
          }
        }

        path {
          path = "/"
          backend {
            service_name = "client-service"
            service_port = 88
          }
        }
      }
    }
  }
}

#-----------------------------> HELM PROVIDER FOR NGINX INGRESS CONTROLLER
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.host
    client_key             = base64decode(azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.cluster_ca_certificate)
  }
}


#-----------------------------> NGINX INGRESS CONTROLLER AKS-FITVERSE
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

}