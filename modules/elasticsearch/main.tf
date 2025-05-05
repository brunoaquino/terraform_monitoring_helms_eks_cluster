resource "kubernetes_namespace" "elasticsearch" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = var.chart_version
  namespace  = var.namespace

  depends_on = [
    kubernetes_namespace.elasticsearch
  ]

  # Usar o arquivo de valores em vez de múltiplos sets
  values = [
    file("${path.module}/values.yaml")
  ]

  # Atualizando alguns valores com as variáveis do módulo
  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "replicas"
    value = tostring(var.elasticsearch_replicas)
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "esJavaOpts"
    value = var.elasticsearch_java_opts
  }

  set {
    name  = "resources.requests.cpu"
    value = var.elasticsearch_resources_requests_cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.elasticsearch_resources_requests_memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.elasticsearch_resources_limits_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.elasticsearch_resources_limits_memory
  }

  set {
    name  = "persistence.size"
    value = var.elasticsearch_storage_size
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = var.elasticsearch_storage_size
  }
}
