output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = var.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint da API do cluster EKS"
  value       = var.eks_cluster_endpoint
}

# Outputs do Prometheus
output "prometheus_namespace" {
  description = "Namespace onde o Prometheus foi instalado"
  value       = module.prometheus.prometheus_namespace
}

output "prometheus_url" {
  description = "URL de acesso ao Prometheus"
  value       = module.prometheus.prometheus_url
}

output "grafana_url" {
  description = "URL de acesso ao Grafana"
  value       = module.prometheus.grafana_url
}

output "alertmanager_url" {
  description = "URL de acesso ao Alertmanager"
  value       = module.prometheus.alertmanager_url
}

# Outputs do Loki
output "loki_namespace" {
  description = "O namespace do Kubernetes onde o Loki foi instalado"
  value       = var.loki_enabled ? module.loki.loki_namespace : "loki-disabled"
}

output "loki_url" {
  description = "URL para acessar o Loki"
  value       = var.loki_enabled ? module.loki.loki_url : "loki-disabled"
}

output "loki_promtail_service" {
  description = "Nome do serviço Promtail para coleta de logs"
  value       = var.loki_enabled ? module.loki.promtail_service : "loki-disabled"
}

output "loki_grafana_datasource" {
  description = "Nome da fonte de dados do Loki no Grafana"
  value       = var.loki_enabled ? module.loki.loki_datasource_name : "loki-disabled"
}

# Outputs do Elasticsearch
output "elasticsearch_namespace" {
  description = "Namespace onde o Elasticsearch foi instalado"
  value       = var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_namespace : "elasticsearch-disabled"
}

output "elasticsearch_url" {
  description = "URL de acesso ao Elasticsearch"
  value       = var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_url : "elasticsearch-disabled"
}

output "elasticsearch_service_name" {
  description = "Nome do serviço Kubernetes do Elasticsearch"
  value       = var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_service_name : "elasticsearch-disabled"
}

output "elasticsearch_port" {
  description = "Porta do serviço Elasticsearch"
  value       = var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_port : 0
}

# Outputs do OpenTelemetry e Jaeger
output "opentelemetry_namespace" {
  description = "Namespace onde o OpenTelemetry foi instalado"
  value       = var.opentelemetry_enabled ? module.opentelemetry.opentelemetry_namespace : "opentelemetry-disabled"
}

output "otel_collector_endpoint" {
  description = "Endpoint do OpenTelemetry Collector"
  value       = var.opentelemetry_enabled ? module.opentelemetry.otel_collector_endpoint : "opentelemetry-disabled"
}

output "otel_collector_grpc_endpoint" {
  description = "Endpoint gRPC do OpenTelemetry Collector"
  value       = var.opentelemetry_enabled ? module.opentelemetry.otel_collector_grpc_endpoint : "opentelemetry-disabled"
}

output "jaeger_url" {
  description = "URL de acesso ao Jaeger UI"
  value       = var.opentelemetry_enabled ? module.opentelemetry.jaeger_url : "jaeger-disabled"
}

# Informações gerais
output "summary" {
  description = "Resumo dos componentes instalados e seus endpoints"
  sensitive   = true
  value       = <<-EOT
    Stack de Monitoramento e Observabilidade

    Cluster EKS:
    - Nome: ${var.eks_cluster_name}
    - Endpoint: ${var.eks_cluster_endpoint}

    Prometheus:
    - Namespace: ${module.prometheus.prometheus_namespace}
    - URL: ${module.prometheus.prometheus_url}

    Grafana:
    - URL: ${module.prometheus.grafana_url}
    - Usuário padrão: admin
    - Senha: ${var.grafana_admin_password}

    Alertmanager:
    - URL: ${module.prometheus.alertmanager_url}

    Loki:
    - Namespace: ${var.loki_enabled ? module.loki.loki_namespace : "loki-disabled"}
    - URL: ${var.loki_enabled ? module.loki.loki_url : "loki-disabled"}

    Elasticsearch:
    - Namespace: ${var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_namespace : "elasticsearch-disabled"}
    - URL: ${var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_url : "elasticsearch-disabled"}
    - Service: ${var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_service_name : "elasticsearch-disabled"}
    - Port: ${var.elasticsearch_enabled ? module.elasticsearch.elasticsearch_port : 0}

    OpenTelemetry e Jaeger:
    - Namespace: ${var.opentelemetry_enabled ? module.opentelemetry.opentelemetry_namespace : "opentelemetry-disabled"}
    - Collector HTTP: ${var.opentelemetry_enabled ? module.opentelemetry.otel_collector_endpoint : "opentelemetry-disabled"}
    - Collector gRPC: ${var.opentelemetry_enabled ? module.opentelemetry.otel_collector_grpc_endpoint : "opentelemetry-disabled"}
    - Jaeger UI: ${var.opentelemetry_enabled ? module.opentelemetry.jaeger_url : "jaeger-disabled"}
  EOT
}
