locals {
  loki_hostname = "${var.loki_subdomain}.${var.base_domain}"
}

resource "kubernetes_namespace" "loki" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = var.chart_version
  namespace  = var.namespace

  depends_on = [
    kubernetes_namespace.loki
  ]

  # Valores básicos
  set {
    name  = "loki.enabled"
    value = "true"
  }

  set {
    name  = "promtail.enabled"
    value = "true"
  }

  # Integração com Grafana
  set {
    name  = "grafana.enabled"
    value = "false" # Não habilitamos o Grafana aqui, pois usaremos o do Prometheus
  }

  # Configuração para persistência do Loki
  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.size"
    value = var.loki_storage_size
  }

  set {
    name  = "loki.persistence.storageClassName"
    value = var.storage_class_name == "" ? "gp2" : var.storage_class_name
  }

  # Configurações de recursos do Loki
  set {
    name  = "loki.resources.requests.cpu"
    value = var.loki_resources_requests_cpu
  }

  set {
    name  = "loki.resources.requests.memory"
    value = var.loki_resources_requests_memory
  }

  set {
    name  = "loki.resources.limits.cpu"
    value = var.loki_resources_limits_cpu
  }

  set {
    name  = "loki.resources.limits.memory"
    value = var.loki_resources_limits_memory
  }

  # Configurações para o Promtail
  set {
    name  = "promtail.resources.requests.cpu"
    value = var.promtail_resources_requests_cpu
  }

  set {
    name  = "promtail.resources.requests.memory"
    value = var.promtail_resources_requests_memory
  }

  set {
    name  = "promtail.resources.limits.cpu"
    value = var.promtail_resources_limits_cpu
  }

  set {
    name  = "promtail.resources.limits.memory"
    value = var.promtail_resources_limits_memory
  }

  # Configuração de retenção dos dados
  set {
    name  = "loki.config.table_manager.retention_deletes_enabled"
    value = "true"
  }

  set {
    name  = "loki.config.table_manager.retention_period"
    value = var.loki_retention
  }
}

# Criar ingress para Loki se habilitado
resource "kubernetes_ingress_v1" "loki_ingress" {
  count = var.create_ingress && var.service_type == "ClusterIP" ? 1 : 0

  metadata {
    name      = "loki-ingress"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_environment == "prod" ? "letsencrypt-prod" : "letsencrypt-staging"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.enable_https ? "true" : "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = local.loki_hostname
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "128k"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
    }
  }

  spec {
    rule {
      host = local.loki_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "loki"
              port {
                number = 3100
              }
            }
          }
        }
      }
    }

    # Configuração TLS para HTTPS
    dynamic "tls" {
      for_each = var.enable_https ? [1] : []

      content {
        hosts       = [local.loki_hostname]
        secret_name = "loki-tls-secret"
      }
    }
  }

  depends_on = [
    helm_release.loki
  ]
}

# Configuração do Grafana Data Source para Loki
# Esta configuração cria um ConfigMap que será automaticamente detectado pelo Grafana
resource "kubernetes_config_map" "loki_datasource" {
  metadata {
    name      = "loki-grafana-datasource"
    namespace = var.prometheus_namespace # Usar o namespace do Prometheus onde o Grafana está instalado

    labels = {
      grafana_datasource = "1" # Importante: essa label permite que o Grafana detecte automaticamente
    }
  }

  data = {
    "loki-datasource.yaml" = <<-EOT
      apiVersion: 1
      datasources:
      - name: Loki
        type: loki
        access: proxy
        url: http://loki.${var.namespace}.svc.cluster.local:3100
        version: 1
        editable: true
        isDefault: false
    EOT
  }

  depends_on = [
    helm_release.loki
  ]
} 
