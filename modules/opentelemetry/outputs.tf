output "opentelemetry_namespace" {
  description = "O namespace do Kubernetes onde o OpenTelemetry foi instalado"
  value       = var.namespace
}

output "otel_collector_endpoint" {
  description = "Endpoint do OpenTelemetry Collector para envio de telemetria"
  value       = "http://opentelemetry-collector-opentelemetry-collector.${var.namespace}.svc.cluster.local:4318"
}

output "otel_collector_grpc_endpoint" {
  description = "Endpoint gRPC do OpenTelemetry Collector para envio de telemetria"
  value       = "opentelemetry-collector-opentelemetry-collector.${var.namespace}.svc.cluster.local:4317"
}

output "jaeger_query_endpoint" {
  description = "Endpoint do serviço de consulta do Jaeger"
  value       = "http://jaeger-query.${var.namespace}.svc.cluster.local:16686"
}

output "jaeger_collector_endpoint" {
  description = "Endpoint do coletor do Jaeger"
  value       = "http://jaeger-collector.${var.namespace}.svc.cluster.local:14268"
}

output "jaeger_url" {
  description = "URL de acesso ao Jaeger UI via Ingress"
  value       = var.create_ingress ? "https://${local.jaeger_hostname}" : "not-configured"
}

output "jaeger_datasource_name" {
  description = "Nome da fonte de dados do Jaeger no Grafana"
  value       = "Jaeger"
} 
