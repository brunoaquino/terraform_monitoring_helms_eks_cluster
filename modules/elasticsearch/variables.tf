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
  default     = ""
}

variable "base_domain" {
  description = "Domínio base para URLs de acesso"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Namespace onde o Elasticsearch será instalado"
  type        = string
  default     = "elasticsearch"
}

variable "create_namespace" {
  description = "Define se o namespace do Elasticsearch será criado"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Versão do chart Helm do Elasticsearch"
  type        = string
  default     = "8.5.1" # Versão do chart Helm
}

variable "service_type" {
  description = "Tipo de serviço Kubernetes para o Elasticsearch"
  type        = string
  default     = "ClusterIP"
}

variable "elasticsearch_storage_size" {
  description = "Tamanho do volume de armazenamento para o Elasticsearch (em Gi)"
  type        = string
  default     = "30Gi"
}

variable "storage_class_name" {
  description = "Nome da storage class a ser utilizada pelos PVCs"
  type        = string
  default     = ""
}

variable "elasticsearch_resources_requests_cpu" {
  description = "Requisição de CPU para o Elasticsearch"
  type        = string
  default     = "100m"
}

variable "elasticsearch_resources_requests_memory" {
  description = "Requisição de memória para o Elasticsearch"
  type        = string
  default     = "512Mi"
}

variable "elasticsearch_resources_limits_cpu" {
  description = "Limite de CPU para o Elasticsearch"
  type        = string
  default     = "1000m"
}

variable "elasticsearch_resources_limits_memory" {
  description = "Limite de memória para o Elasticsearch"
  type        = string
  default     = "1Gi"
}

variable "elasticsearch_replicas" {
  description = "Número de réplicas para o Elasticsearch"
  type        = number
  default     = 1
}

variable "elasticsearch_retention" {
  description = "Retenção de dados do Elasticsearch (em dias)"
  type        = string
  default     = "7d"
}

variable "wait_for_storage" {
  description = "Define se aguardar pelos volumes persistentes estarem prontos"
  type        = bool
  default     = true
}
