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
  EOT
}
