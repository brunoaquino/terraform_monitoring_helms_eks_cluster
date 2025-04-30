locals {
  prometheus_hostname   = "${var.prometheus_subdomain}.${var.base_domain}"
  grafana_hostname      = "${var.grafana_subdomain}.${var.base_domain}"
  alertmanager_hostname = "${var.alertmanager_subdomain}.${var.base_domain}"
}

resource "kubernetes_namespace" "prometheus" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  namespace  = var.namespace

  depends_on = [
    kubernetes_namespace.prometheus
  ]

  # Valores básicos
  set {
    name  = "prometheus.service.type"
    value = var.service_type
  }

  # Configuração do Grafana incluído no stack
  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "grafana.service.type"
    value = var.service_type
  }

  # Credenciais do Grafana - admin/admin por padrão
  # A senha pode ser alterada após o primeiro login ou por meio de secret
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password == "" ? "admin" : var.grafana_admin_password
  }

  # Configuração de retenção dos dados
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = var.prometheus_retention
  }

  # Configuração de recursos
  set {
    name  = "prometheus.prometheusSpec.resources.requests.cpu"
    value = var.prometheus_resources_requests_cpu
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = var.prometheus_resources_requests_memory
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.cpu"
    value = var.prometheus_resources_limits_cpu
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = var.prometheus_resources_limits_memory
  }

  # Configurações de persistência
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = var.prometheus_storage_size
  }

  # Configurar a classe de armazenamento para o Prometheus
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = var.storage_class_name == "" ? "gp2" : var.storage_class_name
  }

  # Configurar a política de espera para volume persistente
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.waitForFirstConsumer"
    value = var.wait_for_storage ? "true" : "false"
  }

  # Configurar tolerações para os pods permitirem agendamento mesmo que não haja volumes disponíveis
  set {
    name  = "prometheus.prometheusSpec.tolerations[0].key"
    value = "node.kubernetes.io/unschedulable"
  }

  set {
    name  = "prometheus.prometheusSpec.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "prometheus.prometheusSpec.tolerations[0].effect"
    value = "NoSchedule"
  }

  # Configurar persistência para o Grafana
  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }

  set {
    name  = "grafana.persistence.size"
    value = var.grafana_storage_size
  }

  # Configurar a classe de armazenamento para o Grafana
  set {
    name  = "grafana.persistence.storageClassName"
    value = var.storage_class_name == "" ? "gp2" : var.storage_class_name
  }

  # Definir o modo de acesso para o Grafana
  set {
    name  = "grafana.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }

  # Configurar persistência para o Alertmanager
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage"
    value = "5Gi"
  }

  # Configurar a classe de armazenamento para o Alertmanager
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName"
    value = var.storage_class_name == "" ? "gp2" : var.storage_class_name
  }

  # Forçar uso de HTTPS 
  set {
    name  = "grafana.grafana.ini.server.protocol"
    value = "https"
  }

  set {
    name  = "grafana.grafana.ini.server.enforce_domain"
    value = "true"
  }

  set {
    name  = "grafana.grafana.ini.server.root_url"
    value = "https://grafana.${var.base_domain}"
  }

  # Configuração para garantir HTTPS nos redirecionamentos
  set {
    name  = "grafana.grafana.ini.security.cookie_secure"
    value = "true"
  }

  set {
    name  = "grafana.grafana.ini.security.strict_transport_security"
    value = "true"
  }

  # Desabilitar integração com Jaeger que está causando erro
  set {
    name  = "grafana.grafana.ini.tracing.enabled"
    value = "false"
  }

  set {
    name  = "grafana.grafana.ini.tracing.jaeger.enabled"
    value = "false"
  }

  set {
    name  = "grafana.env.JAEGER_AGENT_PORT"
    value = ""
  }

  set {
    name  = "grafana.env.JAEGER_DISABLED"
    value = "true"
  }

  # Prometheus também com HTTPS forçado
  set {
    name  = "prometheus.prometheusSpec.externalUrl"
    value = "https://prometheus.${var.base_domain}"
  }

  # Configuração de dashboards predefinidos para Kubernetes
  set {
    name  = "grafana.defaultDashboardsEnabled"
    value = "true"
  }

  set {
    name  = "grafana.defaultDashboardsTimezone"
    value = "browser"
  }

  # Habilitar sidecar para automaticamente detectar ConfigMaps com dashboards
  set {
    name  = "grafana.sidecar.dashboards.enabled"
    value = "true"
  }

  # Configurações de alertas do Prometheus
  set {
    name  = "alertmanager.enabled"
    value = "true"
  }

  set {
    name  = "alertmanager.config.global.resolve_timeout"
    value = "5m"
  }

  # Habilitar auto-descoberta de regras de alertas
  set {
    name  = "prometheusOperator.admissionWebhooks.enabled"
    value = "true"
  }

  set {
    name  = "prometheusOperator.admissionWebhooks.patch.enabled"
    value = "true"
  }

  # Monitoramento automático de nós do Kubernetes
  set {
    name  = "nodeExporter.enabled"
    value = "true"
  }

  # Habilitar Prometheus Service Monitor para aplicações
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}

# Criar ingress para Prometheus se habilitado
resource "kubernetes_ingress_v1" "prometheus_ingress" {
  count = var.create_ingress && var.service_type == "ClusterIP" ? 1 : 0

  metadata {
    name      = "prometheus-ingress"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_environment == "prod" ? "letsencrypt-prod" : "letsencrypt-staging"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.enable_https ? "true" : "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = local.prometheus_hostname
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "128k"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
    }
  }

  spec {
    rule {
      host = local.prometheus_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "prometheus-kube-prometheus-prometheus"
              port {
                number = 9090
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
        hosts       = [local.prometheus_hostname]
        secret_name = "prometheus-tls-secret"
      }
    }
  }

  depends_on = [
    helm_release.prometheus
  ]
}

# Criar ingress para Grafana se habilitado
resource "kubernetes_ingress_v1" "grafana_ingress" {
  count = var.create_ingress && var.service_type == "ClusterIP" ? 1 : 0

  metadata {
    name      = "grafana-ingress"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_environment == "prod" ? "letsencrypt-prod" : "letsencrypt-staging"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.enable_https ? "true" : "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = local.grafana_hostname
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "128k"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
    }
  }

  spec {
    rule {
      host = local.grafana_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "prometheus-grafana"
              port {
                number = 80
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
        hosts       = [local.grafana_hostname]
        secret_name = "grafana-tls-secret"
      }
    }
  }

  depends_on = [
    helm_release.prometheus
  ]
}

# Criar ingress para Alertmanager se habilitado
resource "kubernetes_ingress_v1" "alertmanager_ingress" {
  count = var.create_ingress && var.service_type == "ClusterIP" ? 1 : 0

  metadata {
    name      = "alertmanager-ingress"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_environment == "prod" ? "letsencrypt-prod" : "letsencrypt-staging"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.enable_https ? "true" : "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = local.alertmanager_hostname
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "128k"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
    }
  }

  spec {
    rule {
      host = local.alertmanager_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "prometheus-kube-prometheus-alertmanager"
              port {
                number = 9093
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
        hosts       = [local.alertmanager_hostname]
        secret_name = "alertmanager-tls-secret"
      }
    }
  }

  depends_on = [
    helm_release.prometheus
  ]
}

