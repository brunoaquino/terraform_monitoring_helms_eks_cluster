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
