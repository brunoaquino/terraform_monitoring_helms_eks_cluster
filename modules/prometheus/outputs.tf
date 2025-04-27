output "prometheus_namespace" {
  description = "O namespace do Kubernetes onde o Prometheus foi instalado"
  value       = var.namespace
}

output "prometheus_url" {
  description = "URL para acessar o Prometheus"
  value       = var.create_ingress ? "https://prometheus.${var.base_domain}" : "https://prometheus-kube-prometheus-prometheus.${var.namespace}.svc.cluster.local:9090"
}

output "grafana_url" {
  description = "URL para acessar o Grafana"
  value       = var.create_ingress ? "https://grafana.${var.base_domain}" : "https://prometheus-grafana.${var.namespace}.svc.cluster.local:80"
}

output "alertmanager_url" {
  description = "URL para acessar o Alertmanager"
  value       = var.create_ingress ? "https://alertmanager.${var.base_domain}" : "https://prometheus-kube-prometheus-alertmanager.${var.namespace}.svc.cluster.local:9093"
}
