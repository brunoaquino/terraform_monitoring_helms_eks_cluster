aws_region           = "us-east-1"
eks_cluster_name     = "app-cluster"
eks_cluster_endpoint = "https://AFFF35229632EC007175C7278792B95A.yl4.us-east-1.eks.amazonaws.com"
eks_cluster_ca_cert  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJUFVsUG5yUFFhYmt3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBME16QXhNakEwTXpoYUZ3MHpOVEEwTWpneE1qQTVNemhhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURxbElrUFRGa2RmeDcvajdpZ0wvU01ZeEZIQStCcEF1VTlSTFNtaStRRjBnNlJSMWxUWngvVzB2Ky8KVFZBRFI1Slo0SUJJWGFQRHNQR1ozSjFrd0RzNU1DZGZDYmt3VXV5SDRZeW9CU3o0Vzc3M3pyNWFZSGY2Q3lsdApsRVZlcHJBZUJWV1VUc0NBRU1xcHJtTXVuWGh2QVVnZW9pYXlGamJaTkJ5NWw4ZU4xUkNDckYzcVZ6eVl5M2xPCmx5Skt0TFBLek9IbStOZFY5SHJjRm56d1NXajNNRkNsbUpxdDZJTWhHNmJnN1VMQmtjcGRBOWJhb1FuS3FzVjEKNHhTbkNCbElxMEQ0SXBtZ1R6NU9NVHV4Q0FDNGEzbVBXMlErNWdMY1hvR2Fsa29IUHovQm1qNDdIU1Fzc0RyZQpmbDFXUnBmYmhHY0dKdWRzU25IY2dBSHB5c3hiQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRcUl5Wk9yc3AvUEJ0UUJ6QkY0S1VWVWlVU01EQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRRE9DV2NsSmNyRAp0VmxuUkN1NXBGVldSZndzMUVxeUt5dldaZTBUN05NWklKeVBCZGNHTit3SmZHdUo1T2ZRcGdDU0FzcVdWaFpOCnNUMk01TGQrMXJxeGlhdGRubUdQZ1FhajhVTUNmdDkwZ2FNWi85QWNPVlh3VVZtd1hEUTFPWkF4T241QVRHSTIKQkd0bE1JMDRGL25vNlFFZ1h4TkRjWnpjbTdzK0gxZXdOSm01Sk12VG8rN2E0R2EyelJKTWpkZllsMS93clU3OApYZHA2SzVCRFh0NEtoUHJqMW81S00rYUh5SStHd3VJTWxIMWlEMjZaVE1ER0NuSHNBWFQwMHBLcnUvMXNuNThyCnJXMGdKQnNEK2VhVXdNYXA2RjB3VWpFdW1TWnJPdi95MkZ3VE5GYTdsNHVaNlVNQk5wVFJHT0pIaVlxMnpsV3MKYStQVEJHTUVxRGg1Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

# Domínio base para Ingress
base_domain = "mixnarede.com.br"

# Subdomínios personalizados para cada serviço
jaeger_subdomain       = "jaeger"
grafana_subdomain      = "grafana"
prometheus_subdomain   = "prometheus"
alertmanager_subdomain = "alertmanager"

# Let's Encrypt - prod ou staging
cert_manager_letsencrypt_server = "prod"

# Configurações do Prometheus
prometheus_namespace        = "monitoring"
prometheus_create_namespace = true
prometheus_chart_version    = "45.27.2"
prometheus_service_type     = "ClusterIP"
prometheus_enable_https     = true
prometheus_create_ingress   = true

# Configurações avançadas do Prometheus
prometheus_retention                 = "7d"
prometheus_resources_requests_cpu    = "500m"
prometheus_resources_requests_memory = "1Gi"
prometheus_resources_limits_cpu      = "1000m"
prometheus_resources_limits_memory   = "2Gi"
prometheus_storage_size              = "10Gi"
grafana_storage_size                 = "5Gi"
grafana_admin_password               = "admin" # Altere isso em produção!

# Configuração da classe de armazenamento
storage_class_name = "gp2"

# Configurações do Jaeger
jaeger_enabled          = true
jaeger_namespace        = "monitoring"
jaeger_create_namespace = false
jaeger_chart_version    = "0.71.7"
jaeger_service_type     = "ClusterIP"
jaeger_enable_https     = true
jaeger_create_ingress   = true

# Configurações de armazenamento do Jaeger
jaeger_storage_type               = "elasticsearch" # Opções: elasticsearch, cassandra, memory
jaeger_deploy_elasticsearch       = true            # Se true, implanta o Elasticsearch junto com o Jaeger
jaeger_elasticsearch_host         = ""              # Deixe vazio para usar o Elasticsearch implantado
jaeger_elasticsearch_port         = "9200"
jaeger_elasticsearch_replicas     = 1      # Número de réplicas do Elasticsearch
jaeger_elasticsearch_storage_size = "20Gi" # Tamanho do volume do Elasticsearch

# Recursos do Jaeger Collector
jaeger_collector_resources_requests_cpu    = "100m"
jaeger_collector_resources_requests_memory = "512Mi"
jaeger_collector_resources_limits_cpu      = "500m"
jaeger_collector_resources_limits_memory   = "1Gi"

# Recursos do Jaeger Query
jaeger_query_resources_requests_cpu    = "100m"
jaeger_query_resources_requests_memory = "512Mi"
jaeger_query_resources_limits_cpu      = "500m"
jaeger_query_resources_limits_memory   = "1Gi"

# Recursos do Jaeger Agent
jaeger_agent_resources_requests_cpu    = "100m"
jaeger_agent_resources_requests_memory = "256Mi"
jaeger_agent_resources_limits_cpu      = "200m"
jaeger_agent_resources_limits_memory   = "512Mi"

# Configurações adicionais do Jaeger
jaeger_retention_days = 7   # Retenção de dados em dias
jaeger_ui_base_path   = "/" # Caminho base da UI

# Autenticação do Jaeger
jaeger_enable_authentication = true    # Habilita autenticação básica
jaeger_username              = "admin" # Usuário para acesso
jaeger_password              = "admin" # Senha para acesso (alterar em produção)

# Configurações do Loki
loki_enabled          = true
loki_namespace        = "monitoring" # Mesmo namespace do Prometheus/Grafana
loki_create_namespace = false        # Não criamos pois usamos o mesmo do Prometheus
loki_chart_version    = "2.9.10"
loki_service_type     = "ClusterIP"
loki_enable_https     = true
loki_create_ingress   = true
loki_storage_size     = "10Gi"
loki_subdomain        = "loki"
loki_retention        = "168h" # 7 dias

# Recursos para Loki
loki_resources_requests_cpu    = "100m"
loki_resources_requests_memory = "512Mi"
loki_resources_limits_cpu      = "500m"
loki_resources_limits_memory   = "1Gi"

# Recursos para Promtail
promtail_resources_requests_cpu    = "50m"
promtail_resources_requests_memory = "256Mi"
promtail_resources_limits_cpu      = "250m"
promtail_resources_limits_memory   = "512Mi"
