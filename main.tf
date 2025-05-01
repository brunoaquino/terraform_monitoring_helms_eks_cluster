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

# Módulo Jaeger
module "jaeger" {
  source = "./modules/jaeger"

  aws_region           = var.aws_region
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_endpoint = var.eks_cluster_endpoint
  eks_cluster_ca_cert  = var.eks_cluster_ca_cert
  base_domain          = var.base_domain

  # Subdomínio personalizado
  jaeger_subdomain = var.jaeger_subdomain

  # Configurações específicas do Jaeger
  namespace                = var.jaeger_enabled ? var.jaeger_namespace : "default-disabled-namespace"
  create_namespace         = var.jaeger_enabled ? var.jaeger_create_namespace : false
  chart_version            = var.jaeger_chart_version
  service_type             = var.jaeger_service_type
  enable_https             = var.jaeger_enable_https
  create_ingress           = var.jaeger_enabled ? var.jaeger_create_ingress : false
  cert_manager_environment = var.cert_manager_letsencrypt_server

  # Configurações de armazenamento
  storage_type               = var.jaeger_storage_type
  elasticsearch_host         = var.jaeger_elasticsearch_host
  elasticsearch_port         = var.jaeger_elasticsearch_port
  deploy_elasticsearch       = var.jaeger_enabled ? var.jaeger_deploy_elasticsearch : false
  elasticsearch_replicas     = var.jaeger_elasticsearch_replicas
  elasticsearch_storage_size = var.jaeger_elasticsearch_storage_size
  storage_class_name         = var.storage_class_name

  # Configurações de recursos
  collector_resources_requests_cpu    = var.jaeger_collector_resources_requests_cpu
  collector_resources_requests_memory = var.jaeger_collector_resources_requests_memory
  collector_resources_limits_cpu      = var.jaeger_collector_resources_limits_cpu
  collector_resources_limits_memory   = var.jaeger_collector_resources_limits_memory

  query_resources_requests_cpu    = var.jaeger_query_resources_requests_cpu
  query_resources_requests_memory = var.jaeger_query_resources_requests_memory
  query_resources_limits_cpu      = var.jaeger_query_resources_limits_cpu
  query_resources_limits_memory   = var.jaeger_query_resources_limits_memory

  agent_resources_requests_cpu    = var.jaeger_agent_resources_requests_cpu
  agent_resources_requests_memory = var.jaeger_agent_resources_requests_memory
  agent_resources_limits_cpu      = var.jaeger_agent_resources_limits_cpu
  agent_resources_limits_memory   = var.jaeger_agent_resources_limits_memory

  # Configurações adicionais
  retention_days   = var.jaeger_retention_days
  ui_base_path     = var.jaeger_ui_base_path
  wait_for_storage = true

  # Autenticação
  enable_authentication = var.jaeger_enable_authentication
  jaeger_username       = var.jaeger_username
  jaeger_password       = var.jaeger_password
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
