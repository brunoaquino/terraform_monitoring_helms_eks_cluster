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

variable "namespace" {
  description = "Namespace do Kubernetes onde o Elasticsearch será instalado"
  type        = string
  default     = "elasticsearch"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace para o Elasticsearch"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Versão do Helm chart do Elasticsearch"
  type        = string
  default     = "7.17.3"
}

variable "service_type" {
  description = "Tipo de serviço para o Elasticsearch (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "elasticsearch_replicas" {
  description = "Número de réplicas para o Elasticsearch"
  type        = number
  default     = 1
}

variable "elasticsearch_heap_size" {
  description = "Tamanho do heap do Java para o Elasticsearch"
  type        = string
  default     = "512m"
}

variable "elasticsearch_resources_requests_cpu" {
  description = "Requisição de CPU para o Elasticsearch"
  type        = string
  default     = "500m"
}

variable "elasticsearch_resources_requests_memory" {
  description = "Requisição de memória para o Elasticsearch"
  type        = string
  default     = "1Gi"
}

variable "elasticsearch_resources_limits_cpu" {
  description = "Limite de CPU para o Elasticsearch"
  type        = string
  default     = "1000m"
}

variable "elasticsearch_resources_limits_memory" {
  description = "Limite de memória para o Elasticsearch"
  type        = string
  default     = "2Gi"
}

variable "elasticsearch_storage_size" {
  description = "Tamanho do volume persistente para o Elasticsearch"
  type        = string
  default     = "30Gi"
}

variable "storage_class_name" {
  description = "Nome da storage class para os volumes persistentes"
  type        = string
  default     = "gp2"
}

variable "wait_for_storage" {
  description = "Define se o deployment deve aguardar os PersistentVolumeClaims serem criados"
  type        = bool
  default     = true
}

variable "elasticsearch_java_opts" {
  description = "Opções adicionais do Java para o Elasticsearch"
  type        = string
  default     = "-Xms512m -Xmx512m"
}

variable "cluster_name" {
  description = "Nome do cluster Elasticsearch"
  type        = string
  default     = "elasticsearch"
} 
