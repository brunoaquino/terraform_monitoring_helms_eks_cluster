output "jaeger_namespace" {
  description = "Namespace onde o Jaeger foi instalado"
  value       = var.namespace != "default-disabled-namespace" ? (var.create_namespace ? kubernetes_namespace.jaeger[0].metadata[0].name : var.namespace) : ""
}

output "jaeger_collector_endpoint" {
  description = "Endpoint do Jaeger Collector"
  value       = var.namespace != "default-disabled-namespace" ? "http://jaeger-collector.${var.namespace}.svc.cluster.local:14268/api/traces" : ""
}

output "jaeger_agent_endpoint" {
  description = "Endpoint do Jaeger Agent"
  value       = var.namespace != "default-disabled-namespace" ? "jaeger-agent.${var.namespace}.svc.cluster.local:6831" : ""
}

output "jaeger_query_url" {
  description = "URL para acessar o UI do Jaeger"
  value       = var.namespace != "default-disabled-namespace" ? (var.create_ingress ? "https://${var.namespace}.${var.base_domain}" : "http://jaeger-query.${var.namespace}.svc.cluster.local:16686") : ""
}

output "elasticsearch_url" {
  description = "URL do Elasticsearch (se implantado com o Jaeger)"
  value       = var.namespace != "default-disabled-namespace" && var.deploy_elasticsearch && var.storage_type == "elasticsearch" ? "http://elasticsearch-master.${var.namespace}.svc.cluster.local:9200" : ""
}

output "jaeger_version" {
  description = "Versão do Jaeger instalada"
  value       = var.namespace != "default-disabled-namespace" ? var.chart_version : ""
}
