
# # Create a namespace for argocd
# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   version = "6.0.1"
#   chart   = "argo-cd"

#   namespace        = "argocd"
#   create_namespace = true

#   set {
#     name  = "server.service.type"
#     value = "LoadBalancer"
#   }
#   set {
#     name  = "global.image.tag"
#     value = "v2.6.1"
#   }
# }

# # use helm provider to install argocd
# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     # token                  = module.eks.cluster_auth_token
#   }
# }

resource "helm_release" "argocd" {
  count = local.create_workloads == true ? 1 : 0

  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.34.6"

  #   namespace = kubernetes_namespace.argocd[0].metadata[0].name
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("values/argocd-values.yaml", { env = var.env })
  ]
}

resource "helm_release" "argocd_apps" {
  count = local.create_workloads == true ? 1 : 0

  name       = "argo-cd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "0.0.8"

  #   namespace = kubernetes_namespace.argocd[0].metadata[0].name
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("values/argocd-apps-values.yaml", { env = var.env })
  ]

  depends_on = [
    helm_release.argocd
  ]
}
