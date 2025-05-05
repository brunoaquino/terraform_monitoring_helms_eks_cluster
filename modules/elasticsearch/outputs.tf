output "elasticsearch_namespace" {
  description = "O namespace do Kubernetes onde o Elasticsearch foi instalado"
  value       = var.namespace
}

output "elasticsearch_url" {
  description = "URL para acessar o Elasticsearch"
  value       = "http://elasticsearch-master.${var.namespace}.svc.cluster.local:9200"
}

output "elasticsearch_service_name" {
  description = "Nome do serviço Kubernetes do Elasticsearch"
  value       = "elasticsearch-master"
}

output "elasticsearch_port" {
  description = "Porta do serviço Elasticsearch"
  value       = 9200
} 
