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

variable "namespace" {
  description = "Namespace do Kubernetes onde o Jaeger será instalado"
  type        = string
  default     = "jaeger"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace para o Jaeger"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Versão do Helm chart do Jaeger"
  type        = string
  default     = "0.71.7"
}

variable "service_type" {
  description = "Tipo de serviço para o Jaeger (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "enable_https" {
  description = "Habilita HTTPS para o Jaeger"
  type        = bool
  default     = true
}

variable "create_ingress" {
  description = "Indica se deve criar um Ingress para o Jaeger"
  type        = bool
  default     = true
}

variable "cert_manager_environment" {
  description = "Servidor do Let's Encrypt (staging ou prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "prod"], var.cert_manager_environment)
    error_message = "O valor de cert_manager_environment deve ser 'staging' ou 'prod'."
  }
}

# Configurações específicas do Jaeger
variable "storage_type" {
  description = "Tipo de armazenamento para o Jaeger (elasticsearch, cassandra ou memory)"
  type        = string
  default     = "elasticsearch"

  validation {
    condition     = contains(["elasticsearch", "cassandra", "memory"], var.storage_type)
    error_message = "O valor de storage_type deve ser 'elasticsearch', 'cassandra' ou 'memory'."
  }
}

variable "elasticsearch_host" {
  description = "Host do Elasticsearch para armazenamento do Jaeger"
  type        = string
  default     = ""
}

variable "elasticsearch_port" {
  description = "Porta do Elasticsearch para armazenamento do Jaeger"
  type        = string
  default     = "9200"
}

variable "collector_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger Collector"
  type        = string
  default     = "100m"
}

variable "collector_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger Collector"
  type        = string
  default     = "512Mi"
}

variable "collector_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger Collector"
  type        = string
  default     = "500m"
}

variable "collector_resources_limits_memory" {
  description = "Limite de memória para o Jaeger Collector"
  type        = string
  default     = "1Gi"
}

variable "query_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger Query"
  type        = string
  default     = "100m"
}

variable "query_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger Query"
  type        = string
  default     = "512Mi"
}

variable "query_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger Query"
  type        = string
  default     = "500m"
}

variable "query_resources_limits_memory" {
  description = "Limite de memória para o Jaeger Query"
  type        = string
  default     = "1Gi"
}

variable "agent_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger Agent"
  type        = string
  default     = "100m"
}

variable "agent_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger Agent"
  type        = string
  default     = "256Mi"
}

variable "agent_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger Agent"
  type        = string
  default     = "200m"
}

variable "agent_resources_limits_memory" {
  description = "Limite de memória para o Jaeger Agent"
  type        = string
  default     = "512Mi"
}

variable "storage_class_name" {
  description = "Nome da storage class para os volumes persistentes"
  type        = string
  default     = "gp2"
}

variable "elasticsearch_storage_size" {
  description = "Tamanho do volume persistente para o Elasticsearch (quando instalado junto com Jaeger)"
  type        = string
  default     = "20Gi"
}

variable "deploy_elasticsearch" {
  description = "Indica se deve implantar o Elasticsearch junto com o Jaeger"
  type        = bool
  default     = true
}

variable "ui_base_path" {
  description = "Caminho base para o UI do Jaeger"
  type        = string
  default     = "/"
}

variable "elasticsearch_replicas" {
  description = "Número de réplicas para o Elasticsearch"
  type        = number
  default     = 1
}

variable "retention_days" {
  description = "Número de dias para retenção de dados no Jaeger"
  type        = number
  default     = 7
}

variable "wait_for_storage" {
  description = "Define se o deployment deve aguardar os PersistentVolumeClaims serem criados"
  type        = bool
  default     = true
}

# Autenticação para o Jaeger
variable "enable_authentication" {
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
