provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = var.eks_cluster_ca_cert != "" ? base64decode(var.eks_cluster_ca_cert) : null
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = var.eks_cluster_ca_cert != "" ? base64decode(var.eks_cluster_ca_cert) : null
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}

# Módulo Prometheus
module "prometheus" {
  source = "./modules/prometheus"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert
  base_domain          = var.base_domain

  # Subdomínios personalizados
  grafana_subdomain      = var.grafana_subdomain
  prometheus_subdomain   = var.prometheus_subdomain
  alertmanager_subdomain = var.alertmanager_subdomain

  # Configurações específicas do Prometheus
  namespace                = var.prometheus_namespace
  create_namespace         = var.prometheus_create_namespace
  chart_version            = var.prometheus_chart_version
  service_type             = var.prometheus_service_type
  enable_https             = var.prometheus_enable_https
  create_ingress           = var.prometheus_create_ingress
  cert_manager_environment = var.cert_manager_letsencrypt_server

  # Configurações avançadas
  grafana_admin_password               = var.grafana_admin_password
  prometheus_retention                 = var.prometheus_retention
  prometheus_resources_requests_cpu    = var.prometheus_resources_requests_cpu
  prometheus_resources_requests_memory = var.prometheus_resources_requests_memory
  prometheus_resources_limits_cpu      = var.prometheus_resources_limits_cpu
  prometheus_resources_limits_memory   = var.prometheus_resources_limits_memory
  prometheus_storage_size              = var.prometheus_storage_size
  grafana_storage_size                 = var.grafana_storage_size
  storage_class_name                   = var.storage_class_name
  wait_for_storage                     = true # Habilitamos a espera por volumes
}

# Módulo Loki
module "loki" {
  source = "./modules/loki"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert
  base_domain          = var.base_domain

  # Subdomínio personalizado
  loki_subdomain = var.loki_subdomain

  # Configurações específicas do Loki
  namespace                = var.loki_enabled ? var.loki_namespace : "default-disabled-namespace"
  prometheus_namespace     = var.prometheus_namespace # Importante para a integração com o Grafana
  create_namespace         = var.loki_enabled ? var.loki_create_namespace : false
  chart_version            = var.loki_chart_version
  service_type             = var.loki_service_type
  enable_https             = var.loki_enable_https
  create_ingress           = var.loki_enabled ? var.loki_create_ingress : false
  cert_manager_environment = var.cert_manager_letsencrypt_server

  # Configurações avançadas
  loki_storage_size                  = var.loki_storage_size
  storage_class_name                 = var.storage_class_name
  loki_resources_requests_cpu        = var.loki_resources_requests_cpu
  loki_resources_requests_memory     = var.loki_resources_requests_memory
  loki_resources_limits_cpu          = var.loki_resources_limits_cpu
  loki_resources_limits_memory       = var.loki_resources_limits_memory
  promtail_resources_requests_cpu    = var.promtail_resources_requests_cpu
  promtail_resources_requests_memory = var.promtail_resources_requests_memory
  promtail_resources_limits_cpu      = var.promtail_resources_limits_cpu
  promtail_resources_limits_memory   = var.promtail_resources_limits_memory
  loki_retention                     = var.loki_retention
  wait_for_storage                   = true # Habilitamos a espera por volumes
}

# Módulo Elasticsearch
module "elasticsearch" {
  source = "./modules/elasticsearch"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert

  # Configurações específicas do Elasticsearch
  namespace        = var.elasticsearch_enabled ? var.elasticsearch_namespace : "default-disabled-namespace"
  create_namespace = var.elasticsearch_enabled ? var.elasticsearch_create_namespace : false
  chart_version    = var.elasticsearch_chart_version
  service_type     = var.elasticsearch_service_type
  cluster_name     = var.elasticsearch_cluster_name

  # Configurações de recursos e JVM
  elasticsearch_replicas                  = var.elasticsearch_replicas
  elasticsearch_heap_size                 = var.elasticsearch_heap_size
  elasticsearch_java_opts                 = var.elasticsearch_java_opts
  elasticsearch_resources_requests_cpu    = var.elasticsearch_resources_requests_cpu
  elasticsearch_resources_requests_memory = var.elasticsearch_resources_requests_memory
  elasticsearch_resources_limits_cpu      = var.elasticsearch_resources_limits_cpu
  elasticsearch_resources_limits_memory   = var.elasticsearch_resources_limits_memory

  # Configurações de armazenamento
  elasticsearch_storage_size = var.elasticsearch_storage_size
  storage_class_name         = var.storage_class_name
  wait_for_storage           = true
}

# Módulo OpenTelemetry com Jaeger
module "opentelemetry" {
  source = "./modules/opentelemetry"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert
  base_domain          = var.base_domain

  # Configurações específicas do OpenTelemetry
  namespace                    = var.opentelemetry_enabled ? var.opentelemetry_namespace : "default-disabled-namespace"
  create_namespace             = var.opentelemetry_enabled ? var.opentelemetry_create_namespace : false
  otel_collector_chart_version = var.otel_collector_chart_version
  jaeger_chart_version         = var.jaeger_chart_version
  service_type                 = var.opentelemetry_service_type

  # Integração com Elasticsearch existente
  elasticsearch_host = "${module.elasticsearch.elasticsearch_service_name}.${module.elasticsearch.elasticsearch_namespace}.svc.cluster.local"
  elasticsearch_port = module.elasticsearch.elasticsearch_port

  # Integração com Prometheus/Grafana existente
  prometheus_namespace = var.prometheus_namespace
  grafana_host         = "prometheus-grafana.${var.prometheus_namespace}.svc.cluster.local"

  # Configurações de Ingress
  create_ingress           = var.opentelemetry_enabled ? var.opentelemetry_create_ingress : false
  enable_https             = true
  cert_manager_environment = var.cert_manager_letsencrypt_server
  jaeger_subdomain         = var.jaeger_subdomain

  # Configurações de recursos
  otel_collector_resources_requests_cpu    = var.otel_collector_resources_requests_cpu
  otel_collector_resources_requests_memory = var.otel_collector_resources_requests_memory
  otel_collector_resources_limits_cpu      = var.otel_collector_resources_limits_cpu
  otel_collector_resources_limits_memory   = var.otel_collector_resources_limits_memory
  jaeger_resources_requests_cpu            = var.jaeger_resources_requests_cpu
  jaeger_resources_requests_memory         = var.jaeger_resources_requests_memory
  jaeger_resources_limits_cpu              = var.jaeger_resources_limits_cpu
  jaeger_resources_limits_memory           = var.jaeger_resources_limits_memory

  depends_on = [
    module.prometheus,
    module.elasticsearch
  ]
}
