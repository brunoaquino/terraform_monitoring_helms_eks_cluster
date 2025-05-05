aws_region           = "us-east-1"
eks_cluster_name     = "app-cluster"
eks_cluster_endpoint = "https://4E2E57E93AF9A2622E28F5A6371664AC.gr7.us-east-1.eks.amazonaws.com"
eks_cluster_ca_cert  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJUEtFTGNxQ1dBKzB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBMU1ETXhNakF5TWpaYUZ3MHpOVEExTURFeE1qQTNNalphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURPTk1oNlJoTkl5ZlROaFMya3ZvblduNEMyNHRJbmlXS1l6dE5EKzI1SXZ6MWpqajZwODU5VmJ1YmcKY3oyZXFibGo5OGdablNXTWRBbGhEQmdBOTFtOHZYZWVNSVFrTWRjU3VSL3FTeXFzYXM0akRVcTY4aktuczViQwplQnNsRThOSFlacGcyaTRKdUdHQmtld1VxM3RyQjgwdzJMaGU4OHJHNXhDZVNLNWlCeUlLVDNHbDhXWG4zd1R5Cjg5TXRhblN6Vldhblc2eTNmZGN2VHU2WW9TSXR2UmREeVc4ejlRb3NGT3drdGNZc3pJSDk2WXA1UUFuMTB6VjUKM2tlVXk2b1lTcnpKbTVqTUZ2Y3RYUmRWQjVCY1dGOGtBRjVjazRORDF4c2RHaEtsYkVSdWxtS2FEM0E3SGlxdQpUWnF6S3l5N0NMMEpnZEVCei9mZ0xFbldTNW5sQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTSXpXQm1vZzJrZlF2T2l2U2lEUWVnOWNnM1dEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQzk5ZlZ3VlNjOAppMkM4ZXd5bUJBUVFDQWsyNTRKTkt4T2Y0ei9jV3NHWHRHWnlxK044eDNiYnRaUGd5NDB2bk5OUW85U0lCMGxBCjJORmJBOG83K3gwNGZpUXhEbVBCbGxaYk03VklPazhxTHFtT0ZrSWdnNkpVOTl4bG84WUdaRUpkYWRyTmgwaEYKRkJnVEExdllxRVh2VTkzMDlWUmNUYXYydGdsY1UxZG1UTmRtbGdDb2RseXR5V0V2V3pLcFkwejRuNTdPUUlWLwoxTUMwNUxpbFJ1QlZGMTBkcEJkeWZrdWdXYm5YdSt4WlRiWmpSYWtldVh0bkpmc1lvMFk2WXl0TFNCdDZXZkEwCkxFMmRkNDJoUEU3M2VWc3lOa2xJNEpGV1BHNjZ1dHJrOWVzUHY4aG1xaHFKRElQbzhMUVhieDVuWUR4M0Y3ZXoKVldTa1dJZnZHNkF4Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

# Domínio base para Ingress
base_domain = "mixnarede.com.br"

# Let's Encrypt - prod ou staging
cert_manager_letsencrypt_server = "prod"

# Subdomínios para acesso aos serviços
grafana_subdomain      = "grafana"
prometheus_subdomain   = "prometheus"
alertmanager_subdomain = "alertmanager"
loki_subdomain         = "loki"

# Configurações do Prometheus
prometheus_namespace        = "monitoring"
prometheus_create_namespace = true
prometheus_chart_version    = "45.27.2"
prometheus_service_type     = "ClusterIP"
prometheus_enable_https     = true
prometheus_create_ingress   = true

# Configurações avançadas do Prometheus
prometheus_retention                 = "7d"
prometheus_resources_requests_cpu    = "250m"
prometheus_resources_requests_memory = "1Gi"
prometheus_resources_limits_cpu      = "500m"
prometheus_resources_limits_memory   = "2Gi"
prometheus_storage_size              = "10Gi"
grafana_storage_size                 = "5Gi"
grafana_admin_password               = "admin" # Altere isso em produção!

# Configurações do Loki
loki_enabled          = true
loki_namespace        = "loki"
loki_create_namespace = true
loki_chart_version    = "2.9.11"
loki_service_type     = "ClusterIP"
loki_enable_https     = true
loki_create_ingress   = true
loki_storage_size     = "10Gi"
loki_retention        = "168h" # 7 dias

# Recursos do Loki
loki_resources_requests_cpu        = "200m"
loki_resources_requests_memory     = "256Mi"
loki_resources_limits_cpu          = "500m"
loki_resources_limits_memory       = "512Mi"
promtail_resources_requests_cpu    = "100m"
promtail_resources_requests_memory = "128Mi"
promtail_resources_limits_cpu      = "200m"
promtail_resources_limits_memory   = "256Mi"

# Configuração da classe de armazenamento
storage_class_name = "gp2" # Classe de armazenamento para volumes persistentes

# Configurações do Elasticsearch
elasticsearch_enabled          = true
elasticsearch_namespace        = "elasticsearch"
elasticsearch_create_namespace = true
elasticsearch_chart_version    = "7.17.3"
elasticsearch_service_type     = "ClusterIP"
elasticsearch_cluster_name     = "elasticsearch"
elasticsearch_replicas         = 1
elasticsearch_storage_size     = "30Gi"

# Configuração de recursos do Elasticsearch
elasticsearch_resources_requests_cpu    = "500m"
elasticsearch_resources_requests_memory = "1Gi"
elasticsearch_resources_limits_cpu      = "1000m"
elasticsearch_resources_limits_memory   = "2Gi"

# Configuração da JVM para o Elasticsearch
elasticsearch_heap_size = "512m"
elasticsearch_java_opts = "-Xms512m -Xmx512m"

# Configurações do OpenTelemetry + Jaeger
opentelemetry_enabled          = true
opentelemetry_namespace        = "opentelemetry"
opentelemetry_create_namespace = true
otel_collector_chart_version   = "0.70.0"
jaeger_chart_version           = "0.71.10"
opentelemetry_service_type     = "ClusterIP"
opentelemetry_create_ingress   = true
jaeger_subdomain               = "jaeger"

# Recursos do OpenTelemetry Collector
otel_collector_resources_requests_cpu    = "100m"
otel_collector_resources_requests_memory = "256Mi"
otel_collector_resources_limits_cpu      = "200m"
otel_collector_resources_limits_memory   = "512Mi"

# Recursos do Jaeger
jaeger_resources_requests_cpu    = "200m"
jaeger_resources_requests_memory = "256Mi"
jaeger_resources_limits_cpu      = "500m"
jaeger_resources_limits_memory   = "512Mi"
