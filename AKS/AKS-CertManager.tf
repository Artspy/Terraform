#-----------------------------> CERT MANAGER AKS-FITVERSE
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  set {
    name  = "installCRDs"
    value = "true"
  }
}
