####################Create ArgoCD Namespace####################
####################PLEASE MAKE SURE YOUR CLUSTER IS CREATED BEFORE DEPLOYING THIS FILE####################

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
    templatefile("values/argo-value.yaml", { env = var.env })
  ]
}

####################Create ArgoCD Apps####################

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
    templatefile("values/apps-value.yaml", { env = var.env })
  ]

  depends_on = [
    helm_release.argocd
  ]
}
####################Create ArgoCD Apps####################
