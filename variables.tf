variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  type        = string
}

variable "eks_cluster_ca_cert" {
  description = "Certificado CA do cluster EKS"
  type        = string
}

variable "base_domain" {
  description = "Domínio base para acesso aos serviços via Ingress"
  type        = string
}

# Referência ao Cert-Manager já instalado no cluster
variable "cert_manager_letsencrypt_server" {
  description = "Servidor do Let's Encrypt (staging ou prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "prod"], var.cert_manager_letsencrypt_server)
    error_message = "O valor de cert_manager_letsencrypt_server deve ser 'staging' ou 'prod'."
  }
}

# Variáveis para o Prometheus
variable "prometheus_namespace" {
  description = "Namespace do Kubernetes onde o Prometheus será instalado"
  type        = string
  default     = "monitoring"
}

variable "prometheus_create_namespace" {
  description = "Se deve criar o namespace para o Prometheus"
  type        = bool
  default     = true
}

variable "prometheus_chart_version" {
  description = "Versão do chart Helm do Prometheus"
  type        = string
  default     = "40.0.0" # Use uma versão específica para consistência
}

variable "prometheus_service_type" {
  description = "Tipo de serviço Kubernetes para o Prometheus"
  type        = string
  default     = "ClusterIP" # Recomendado para produção com Ingress
}

variable "prometheus_enable_https" {
  description = "Se deve habilitar HTTPS para o Prometheus"
  type        = bool
  default     = true
}

variable "prometheus_create_ingress" {
  description = "Se deve criar um Ingress para o Prometheus"
  type        = bool
  default     = true
}

variable "grafana_admin_password" {
  description = "Senha do administrador do Grafana"
  type        = string
  default     = "admin" # Alterar em produção
  sensitive   = true
}

variable "prometheus_retention" {
  description = "Período de retenção de dados no Prometheus"
  type        = string
  default     = "15d" # 15 dias
}

variable "prometheus_resources_requests_cpu" {
  description = "Requisição de CPU para o Prometheus"
  type        = string
  default     = "500m"
}

variable "prometheus_resources_requests_memory" {
  description = "Requisição de memória para o Prometheus"
  type        = string
  default     = "1Gi"
}

variable "prometheus_resources_limits_cpu" {
  description = "Limite de CPU para o Prometheus"
  type        = string
  default     = "1000m"
}

variable "prometheus_resources_limits_memory" {
  description = "Limite de memória para o Prometheus"
  type        = string
  default     = "2Gi"
}

variable "prometheus_storage_size" {
  description = "Tamanho do volume de armazenamento para o Prometheus"
  type        = string
  default     = "10Gi"
}

variable "grafana_storage_size" {
  description = "Tamanho do volume de armazenamento para o Grafana"
  type        = string
  default     = "5Gi"
}

variable "storage_class_name" {
  description = "Nome da classe de armazenamento a ser usada para volumes persistentes"
  type        = string
  default     = "gp2" # Padrão para AWS EKS
}

# Variáveis para o Jaeger
variable "jaeger_enabled" {
  description = "Se o Jaeger deve ser habilitado"
  type        = bool
  default     = true
}

variable "jaeger_namespace" {
  description = "Namespace do Kubernetes onde o Jaeger será instalado"
  type        = string
  default     = "jaeger"
}

variable "jaeger_create_namespace" {
  description = "Se deve criar o namespace para o Jaeger"
  type        = bool
  default     = true
}

variable "jaeger_chart_version" {
  description = "Versão do chart Helm do Jaeger"
  type        = string
  default     = "0.71.7"
}

variable "jaeger_service_type" {
  description = "Tipo de serviço Kubernetes para o Jaeger"
  type        = string
  default     = "ClusterIP"
}

variable "jaeger_enable_https" {
  description = "Se deve habilitar HTTPS para o Jaeger"
  type        = bool
  default     = true
}

variable "jaeger_create_ingress" {
  description = "Se deve criar um Ingress para o Jaeger"
  type        = bool
  default     = true
}

variable "jaeger_storage_type" {
  description = "Tipo de armazenamento para o Jaeger (elasticsearch, cassandra ou memory)"
  type        = string
  default     = "elasticsearch"

  validation {
    condition     = contains(["elasticsearch", "cassandra", "memory"], var.jaeger_storage_type)
    error_message = "O valor de jaeger_storage_type deve ser 'elasticsearch', 'cassandra' ou 'memory'."
  }
}

variable "jaeger_elasticsearch_host" {
  description = "Host do Elasticsearch para armazenamento do Jaeger"
  type        = string
  default     = ""
}

variable "jaeger_elasticsearch_port" {
  description = "Porta do Elasticsearch para armazenamento do Jaeger"
  type        = string
  default     = "9200"
}

variable "jaeger_deploy_elasticsearch" {
  description = "Se deve implantar o Elasticsearch junto com o Jaeger"
  type        = bool
  default     = true
}

variable "jaeger_elasticsearch_replicas" {
  description = "Número de réplicas para o Elasticsearch"
  type        = number
  default     = 1
}

variable "jaeger_elasticsearch_storage_size" {
  description = "Tamanho do volume de armazenamento para o Elasticsearch"
  type        = string
  default     = "20Gi"
}

variable "jaeger_collector_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger Collector"
  type        = string
  default     = "100m"
}

variable "jaeger_collector_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger Collector"
  type        = string
  default     = "512Mi"
}

variable "jaeger_collector_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger Collector"
  type        = string
  default     = "500m"
}

variable "jaeger_collector_resources_limits_memory" {
  description = "Limite de memória para o Jaeger Collector"
  type        = string
  default     = "1Gi"
}

variable "jaeger_query_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger Query"
  type        = string
  default     = "100m"
}

variable "jaeger_query_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger Query"
  type        = string
  default     = "512Mi"
}

variable "jaeger_query_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger Query"
  type        = string
  default     = "500m"
}

variable "jaeger_query_resources_limits_memory" {
  description = "Limite de memória para o Jaeger Query"
  type        = string
  default     = "1Gi"
}

variable "jaeger_agent_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger Agent"
  type        = string
  default     = "100m"
}

variable "jaeger_agent_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger Agent"
  type        = string
  default     = "256Mi"
}

variable "jaeger_agent_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger Agent"
  type        = string
  default     = "200m"
}

variable "jaeger_agent_resources_limits_memory" {
  description = "Limite de memória para o Jaeger Agent"
  type        = string
  default     = "512Mi"
}

variable "jaeger_retention_days" {
  description = "Número de dias para retenção de dados no Jaeger"
  type        = number
  default     = 7
}

variable "jaeger_ui_base_path" {
  description = "Caminho base para o UI do Jaeger"
  type        = string
  default     = "/"
}

# Autenticação do Jaeger
variable "jaeger_enable_authentication" {
  description = "Ativa a autenticação para o Jaeger Query UI"
  type        = bool
  default     = false
}

variable "jaeger_username" {
  description = "Nome de usuário para acesso à interface do Jaeger"
  type        = string
  default     = "admin"
}

variable "jaeger_password" {
  description = "Senha para acesso à interface do Jaeger"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "jaeger_subdomain" {
  description = "Subdomínio para acesso ao Jaeger (será combinado com base_domain)"
  type        = string
  default     = "jaeger"
}

variable "grafana_subdomain" {
  description = "Subdomínio para acesso ao Grafana (será combinado com base_domain)"
  type        = string
  default     = "grafana"
}

variable "prometheus_subdomain" {
  description = "Subdomínio para acesso ao Prometheus (será combinado com base_domain)"
  type        = string
  default     = "prometheus"
}

variable "alertmanager_subdomain" {
  description = "Subdomínio para acesso ao Alertmanager (será combinado com base_domain)"
  type        = string
  default     = "alertmanager"
}

# Variáveis para o Loki
variable "loki_enabled" {
  description = "Se o Loki deve ser habilitado"
  type        = bool
  default     = true
}

variable "loki_namespace" {
  description = "Namespace do Kubernetes onde o Loki será instalado"
  type        = string
  default     = "monitoring" # Usamos o mesmo namespace do Prometheus/Grafana para facilitar a integração
}

variable "loki_create_namespace" {
  description = "Se deve criar o namespace para o Loki"
  type        = bool
  default     = false # Por padrão, não cria pois usamos o mesmo do Prometheus
}

variable "loki_chart_version" {
  description = "Versão do chart Helm do Loki"
  type        = string
  default     = "2.9.10"
}

variable "loki_service_type" {
  description = "Tipo de serviço Kubernetes para o Loki"
  type        = string
  default     = "ClusterIP"
}

variable "loki_enable_https" {
  description = "Se deve habilitar HTTPS para o Loki"
  type        = bool
  default     = true
}

variable "loki_create_ingress" {
  description = "Se deve criar um Ingress para o Loki"
  type        = bool
  default     = true
}

variable "loki_storage_size" {
  description = "Tamanho do volume de armazenamento para o Loki"
  type        = string
  default     = "10Gi"
}

variable "loki_resources_requests_cpu" {
  description = "Requisição de CPU para o Loki"
  type        = string
  default     = "100m"
}

variable "loki_resources_requests_memory" {
  description = "Requisição de memória para o Loki"
  type        = string
  default     = "512Mi"
}

variable "loki_resources_limits_cpu" {
  description = "Limite de CPU para o Loki"
  type        = string
  default     = "500m"
}

variable "loki_resources_limits_memory" {
  description = "Limite de memória para o Loki"
  type        = string
  default     = "1Gi"
}

variable "promtail_resources_requests_cpu" {
  description = "Requisição de CPU para o Promtail"
  type        = string
  default     = "50m"
}

variable "promtail_resources_requests_memory" {
  description = "Requisição de memória para o Promtail"
  type        = string
  default     = "256Mi"
}

variable "promtail_resources_limits_cpu" {
  description = "Limite de CPU para o Promtail"
  type        = string
  default     = "250m"
}

variable "promtail_resources_limits_memory" {
  description = "Limite de memória para o Promtail"
  type        = string
  default     = "512Mi"
}

variable "loki_retention" {
  description = "Período de retenção dos dados no Loki"
  type        = string
  default     = "168h" # 7 dias
}

variable "loki_subdomain" {
  description = "Subdomínio para acesso ao Loki (será combinado com base_domain)"
  type        = string
  default     = "loki"
}
