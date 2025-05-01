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

# Outputs do Jaeger
output "jaeger_namespace" {
  description = "Namespace onde o Jaeger foi instalado"
  value       = var.jaeger_enabled ? module.jaeger.jaeger_namespace : ""
}

output "jaeger_query_url" {
  description = "URL de acesso ao UI do Jaeger"
  value       = var.jaeger_enabled ? module.jaeger.jaeger_query_url : ""
}

output "jaeger_collector_endpoint" {
  description = "Endpoint do Jaeger Collector para envio de traces"
  value       = var.jaeger_enabled ? module.jaeger.jaeger_collector_endpoint : ""
}

output "jaeger_agent_endpoint" {
  description = "Endpoint do Jaeger Agent para envio de traces"
  value       = var.jaeger_enabled ? module.jaeger.jaeger_agent_endpoint : ""
}

output "elasticsearch_url" {
  description = "URL do Elasticsearch do Jaeger (se implantado)"
  value       = var.jaeger_enabled && var.jaeger_deploy_elasticsearch && var.jaeger_storage_type == "elasticsearch" ? module.jaeger.elasticsearch_url : ""
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

# Informações gerais
output "summary" {
  description = "Resumo dos componentes instalados e seus endpoints"
  sensitive   = true
  value = <<-EOT
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
    ${var.jaeger_enabled ? <<EOJ

    Jaeger:
    - Namespace: ${module.jaeger.jaeger_namespace}
    - UI URL: ${module.jaeger.jaeger_query_url}
    - Collector Endpoint: ${module.jaeger.jaeger_collector_endpoint}
    - Agent Endpoint: ${module.jaeger.jaeger_agent_endpoint}
    ${var.jaeger_deploy_elasticsearch && var.jaeger_storage_type == "elasticsearch" ? "- Elasticsearch URL: ${module.jaeger.elasticsearch_url}" : ""}
    EOJ
: ""}
  EOT
}
