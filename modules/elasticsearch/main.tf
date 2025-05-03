############################
# Namespace para Elasticsearch
############################
resource "kubernetes_namespace" "elasticsearch" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

############################
# Release Helm do Elasticsearch
############################
resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace
  wait             = true
  wait_for_jobs    = true
  timeout          = 600

  values = [
    yamlencode({
      replicas = var.elasticsearch_replicas

      resources = {
        requests = {
          cpu    = var.elasticsearch_resources_requests_cpu
          memory = var.elasticsearch_resources_requests_memory
        }
        limits = {
          cpu    = var.elasticsearch_resources_limits_cpu
          memory = var.elasticsearch_resources_limits_memory
        }
      }

      # Configuração do volume de armazenamento usando o gp2
      volumeClaimTemplate = {
        accessModes      = ["ReadWriteOnce"]
        storageClassName = var.storage_class_name == "" ? "gp2" : var.storage_class_name
        resources = {
          requests = {
            storage = var.elasticsearch_storage_size
          }
        }
      }

      # Desabilitando autenticação
      antiAffinity = "soft"

      esConfig = {
        "elasticsearch.yml" = <<EOF
          xpack.security.enabled: false
          xpack.security.transport.ssl.enabled: false
          xpack.security.http.ssl.enabled: false
EOF
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.elasticsearch
  ]
}
