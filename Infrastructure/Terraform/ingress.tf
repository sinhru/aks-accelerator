provider "helm" {
  alias = "aks"
  kubernetes {
    host                   = module.azurerm_kubernetes_cluster.host
    client_certificate     = base64decode(module.azurerm_kubernetes_cluster.client_certificate)
    client_key             = base64decode(module.azurerm_kubernetes_cluster.client_key)
    cluster_ca_certificate = base64decode(module.azurerm_kubernetes_cluster.cluster_ca_certificate)
  }
}

resource "helm_release" "nginx_ingress" {
  name       = var.ingress_name
  provider = helm.aks
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "3.4.1"
  
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.linkerd\\.io/inject"
    value = "false"
    type = "string"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "true"
    type = "string"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal-subnet"
    value = "iaas-private"
    type = "string"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-external-subnet"
    value = "iaas-public"
    type = "string"
  }
  set {
    name = "controller.ingressClass"
    value = var.ingress_class
  }
}

data "kubernetes_service" "service_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "default"
  }

  depends_on = [ helm_release.nginx_ingress ] 
}