#-----------------------------> POD DEPLOYMENT MEMBERSSERVICE
resource "kubernetes_deployment" "membersservice" {
  depends_on = [
    kubernetes_stateful_set.statefulset-rabbits
  ]
  metadata {
    name = "membersservice-deployment"
    labels = {
      app = "MembersService"
      name = "membersservice"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "MembersService"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "25%"
        max_surge = "50%"
      }
    }

    template {
      metadata {
        labels = {
          app = "MembersService"
        }
      }

      spec {
        container {
          name  = "membersservice"
          image = "-"
          port {
            container_port = 5003
            name = "ms-port"
          }
          port {
            container_port = 80
            name = "health-port"
          }
          resources {
            requests = {
              cpu    = "25m"
              memory = "42Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

#-----------------------------> SERVICE MEMBERSSERVICE
resource "kubernetes_service" "service-membersservice" {
  depends_on = [
  kubernetes_deployment.membersservice
  ]
  metadata {
    name = "ms-service"
  }
  spec {
    type = "ClusterIP"
    port {
      port          = 83
      target_port   = 5003
      name          = "ms-port"
    }
    
    selector = {
      app = "MembersService"
    }
  }
}

#-----------------------------> POD DEPLOYMENT AGREEMENTSSERVICE
resource "kubernetes_deployment" "agreementsservice" {
  depends_on = [
    kubernetes_stateful_set.statefulset-rabbits
  ]
  metadata {
    name = "agreementsservice-deployment"
    labels = {
      app = "AgreementsService"
      name = "agreementsservice"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "AgreementsService"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "25%"
        max_surge = "50%"
      }
    }

    template {
      metadata {
        labels = {
          app = "AgreementsService"
        }
      }

      spec {
        container {
          name  = "agreementsservice"
          image = "-"
          port {
            container_port = 5005
            name = "as-port"
          }
          port {
            container_port = 80
            name = "health-port"
          }
          resources {
            requests = {
              cpu    = "25m"
              memory = "32Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

#-----------------------------> SERVICE AGREEMENTSSERVICE
resource "kubernetes_service" "service-agreementsservice" {
  depends_on = [
  kubernetes_deployment.agreementsservice
  ]
  metadata {
    name = "as-service"
  }
  spec {
    type = "ClusterIP"
    port {
      port          = 85
      target_port   = 5005
      name          = "as-port"
    }
    
    selector = {
      app = "AgreementsService"
    }
  }
}

#-----------------------------> POD DEPLOYMENT CALENDARSERVICE
resource "kubernetes_deployment" "calendarservice" {
  depends_on = [
    kubernetes_stateful_set.statefulset-rabbits
  ]
  metadata {
    name = "calendarservice-deployment"
    labels = {
      app = "CalendarService"
      name = "calendarservice"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "CalendarService"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "25%"
        max_surge = "50%"
      }
    }

    template {
      metadata {
        labels = {
          app = "CalendarService"
        }
      }

      spec {
        container {
          name  = "calendarservice"
          image = "-"
          port {
            container_port = 5007
            name = "cs-port"
          }
          port {
            container_port = 80
            name = "health-port"
          }
          resources {
            requests = {
              cpu    = "25m"
              memory = "32Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

#-----------------------------> SERVICE CALENDARSERVICE
resource "kubernetes_service" "service-calendarservice" {
  depends_on = [
  kubernetes_deployment.calendarservice
  ]
  metadata {
    name = "cs-service"
  }
  spec {
    type = "ClusterIP"
    port {
      port          = 87
      target_port   = 5007
      name          = "cs-port"
    }
    
    selector = {
      app = "CalendarService"
    }
  }
}
#-----------------------------> POD DEPLOYMENT CLIENT
resource "kubernetes_deployment" "client" {
  depends_on = [
    kubernetes_stateful_set.statefulset-rabbits
  ]
  metadata {
    name = "client-deployment"
    labels = {
      app = "client"
      name = "client"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "client"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "25%"
        max_surge = "50%"
      }
    }

    template {
      metadata {
        labels = {
          app = "client"
        }
      }

      spec {
        container {
          name  = "client"
          image = "-"
          port {
            container_port = 80
            name = "client-port"
          }
          port {
            container_port = 80
            name = "health-port"
          }
          resources {
            requests = {
              cpu    = "25m"
              memory = "32Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

#-----------------------------> SERVICE CLIENT
resource "kubernetes_service" "service-client" {
  depends_on = [
  kubernetes_deployment.client
  ]
  metadata {
    name = "client-service"
  }
  spec {
    type = "ClusterIP"
    port {
      port          = 88
      target_port   = 80
      name          = "client-port"
    }
    
    selector = {
      app = "client"
    }
  }
}

#-----------------------------> POD DEPLOYMENT AUTHSERVICE
resource "kubernetes_deployment" "authservice" {
  depends_on = [
    kubernetes_stateful_set.statefulset-rabbits
  ]
  metadata {
    name = "authservice-deployment"
    labels = {
      app = "AuthService"
      name = "authservice"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "AuthService"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "25%"
        max_surge = "50%"
      }
    }

    template {
      metadata {
        labels = {
          app = "AuthService"
        }
      }

      spec {
        container {
          name  = "authservice"
          image = "-"
          port {
            container_port = 5009
            name = "as-port"
          }
          port {
            container_port = 80
            name = "health-port"
          }
          resources {
            requests = {
              cpu    = "25m"
              memory = "42Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

#-----------------------------> SERVICE AUTHSERVICE
resource "kubernetes_service" "service-authservice" {
  depends_on = [
  kubernetes_deployment.authservice
  ]
  metadata {
    name = "auth-service"
  }
  spec {
    type = "ClusterIP"
    port {
      port          = 89
      target_port   = 5009
      name          = "auth-port"
    }
    
    selector = {
      app = "AuthService"
    }
  }
}