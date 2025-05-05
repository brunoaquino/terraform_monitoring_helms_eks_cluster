locals {
  jaeger_hostname = "${var.jaeger_subdomain}.${var.base_domain}"
}

resource "kubernetes_namespace" "opentelemetry" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}

# Deploy do OpenTelemetry Collector
resource "helm_release" "opentelemetry_collector" {
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = var.otel_collector_chart_version
  namespace  = var.namespace

  depends_on = [
    kubernetes_namespace.opentelemetry
  ]

  # Usando o set para definir valores em vez de arquivo de template
  # Modo do collector (deployment, daemonset, statefulset)
  set {
    name  = "mode"
    value = "deployment"
  }

  # Configurações de serviço
  set {
    name  = "service.type"
    value = var.service_type
  }

  # Configurações de recursos
  set {
    name  = "resources.requests.cpu"
    value = var.otel_collector_resources_requests_cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.otel_collector_resources_requests_memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.otel_collector_resources_limits_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.otel_collector_resources_limits_memory
  }

  # Configuração do collector para Elasticsearch
  set {
    name  = "config.exporters.elasticsearch.endpoints[0]"
    value = "http://${var.elasticsearch_host}:${var.elasticsearch_port}"
  }

  # Habilitando portas necessárias
  set {
    name  = "ports.otlp.enabled"
    value = "true"
  }

  set {
    name  = "ports.otlp-http.enabled"
    value = "true"
  }

  set {
    name  = "ports.jaeger-compact.enabled"
    value = "true"
  }

  set {
    name  = "ports.jaeger-thrift.enabled"
    value = "true"
  }

  set {
    name  = "ports.jaeger-grpc.enabled"
    value = "true"
  }

  # Configuração completa via arquivo de valores
  values = [
    templatefile("${path.module}/opentelemetry-collector-config.yaml", {
      service_type                             = var.service_type
      elasticsearch_host                       = var.elasticsearch_host
      elasticsearch_port                       = var.elasticsearch_port
      otel_collector_resources_requests_cpu    = var.otel_collector_resources_requests_cpu
      otel_collector_resources_requests_memory = var.otel_collector_resources_requests_memory
      otel_collector_resources_limits_cpu      = var.otel_collector_resources_limits_cpu
      otel_collector_resources_limits_memory   = var.otel_collector_resources_limits_memory
    })
  ]
}

# Deploy do Jaeger
resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"
  version    = var.jaeger_chart_version
  namespace  = var.namespace

  depends_on = [
    kubernetes_namespace.opentelemetry,
    helm_release.opentelemetry_collector
  ]

  # Configurar com values template
  values = [
    templatefile("${path.module}/jaeger-values.yaml", {
      namespace                        = var.namespace
      service_type                     = var.service_type
      elasticsearch_host               = var.elasticsearch_host
      elasticsearch_port               = var.elasticsearch_port
      jaeger_resources_requests_cpu    = var.jaeger_resources_requests_cpu
      jaeger_resources_requests_memory = var.jaeger_resources_requests_memory
      jaeger_resources_limits_cpu      = var.jaeger_resources_limits_cpu
      jaeger_resources_limits_memory   = var.jaeger_resources_limits_memory
    })
  ]
}

# Adicionar datasource do Jaeger ao Grafana
resource "kubernetes_manifest" "grafana_jaeger_datasource" {
  manifest = yamldecode(templatefile("${path.module}/grafana-jaeger-datasource.yaml", {
    prometheus_namespace = var.prometheus_namespace
    namespace            = var.namespace
  }))

  depends_on = [
    helm_release.jaeger
  ]
}

# Criar Ingress para o Jaeger UI
resource "kubernetes_ingress_v1" "jaeger_ingress" {
  count = var.create_ingress ? 1 : 0

  metadata {
    name      = "jaeger-query-ingress"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_environment == "staging" ? "letsencrypt-staging" : "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.enable_https ? "true" : "false"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "90"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "90"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/"
      "external-dns.alpha.kubernetes.io/hostname"      = local.jaeger_hostname
    }
  }

  spec {
    rule {
      host = local.jaeger_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "jaeger-query"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.jaeger_hostname]
      secret_name = "jaeger-tls-secret"
    }
  }

  depends_on = [
    helm_release.jaeger
  ]
}
