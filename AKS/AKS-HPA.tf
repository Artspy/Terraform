#-----------------------------> HPA FOR MEMBERSSERVICE
resource "kubernetes_horizontal_pod_autoscaler" "HPA-Membersservice" {
  depends_on = [
    kubernetes_deployment.membersservice
  ]
  metadata {
    name = "hpa-membersservice"
  }

  spec {
    min_replicas = 2
    max_replicas = 10

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "membersservice-deployment"
    }
    target_cpu_utilization_percentage = "85"

  }
}

#-----------------------------> HPA FOR AGREEMENTSSERVICE
resource "kubernetes_horizontal_pod_autoscaler" "HPA-Agreementsservice" {
  depends_on = [
    kubernetes_deployment.agreementsservice
  ]
  metadata {
    name = "hpa-agreementsservice"
  }

  spec {
    min_replicas = 2
    max_replicas = 10

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "agreementsservice-deployment"
    }
    target_cpu_utilization_percentage = "85"

  }
}

#-----------------------------> HPA FOR CALENDARSERVICE
resource "kubernetes_horizontal_pod_autoscaler" "HPA-Calendarservice" {
  depends_on = [
    kubernetes_deployment.calendarservice
  ]
  metadata {
    name = "hpa-calendarservice"
  }

  spec {
    min_replicas = 2
    max_replicas = 10

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "calendarservice-deployment"
    }
    target_cpu_utilization_percentage = "85"

  }
}

#-----------------------------> HPA FOR CLIENT
resource "kubernetes_horizontal_pod_autoscaler" "HPA-Client" {
  depends_on = [
    kubernetes_deployment.client
  ]
  metadata {
    name = "hpa-client"
  }

  spec {
    min_replicas = 1
    max_replicas = 10

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "client-deployment"
    }
    target_cpu_utilization_percentage = "85"

  }
}

#-----------------------------> HPA FOR AUTHSERVICE
resource "kubernetes_horizontal_pod_autoscaler" "HPA-AuthService" {
  depends_on = [
    kubernetes_deployment.authservice
  ]
  metadata {
    name = "hpa-auth"
  }

  spec {
    min_replicas = 1
    max_replicas = 10

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "authservice-deployment"
    }
    target_cpu_utilization_percentage = "85"

  }
}
