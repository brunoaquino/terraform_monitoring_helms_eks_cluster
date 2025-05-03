output "elasticsearch_namespace" {
  description = "Namespace onde o Elasticsearch foi instalado"
  value       = var.namespace
}

output "elasticsearch_url" {
  description = "URL interna para acesso ao Elasticsearch dentro do cluster"
  value       = "http://elasticsearch-master.${var.namespace}.svc.cluster.local:9200"
}

output "elasticsearch_service_name" {
  description = "Nome do serviço do Elasticsearch"
  value       = "elasticsearch-master"
}
