output "loki_namespace" {
  description = "O namespace do Kubernetes onde o Loki foi instalado"
  value       = var.namespace
}

output "loki_url" {
  description = "URL para acessar o Loki"
  value       = var.create_ingress ? "https://${var.loki_subdomain}.${var.base_domain}" : "http://loki.${var.namespace}.svc.cluster.local:3100"
}

output "promtail_service" {
  description = "Nome do serviço Promtail para coleta de logs"
  value       = "loki-promtail"
}

output "loki_datasource_name" {
  description = "Nome da fonte de dados do Loki no Grafana"
  value       = "Loki"
} 
