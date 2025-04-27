aws_region           = "us-east-1"
eks_cluster_name     = "app-cluster"
eks_cluster_endpoint = "https://C790C43D70761FCCA628E2CBE1704AF2.sk1.us-east-1.eks.amazonaws.com"
eks_cluster_ca_cert  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJYzJwdmZjZFZRMTR3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBME1qY3hOREEwTlRsYUZ3MHpOVEEwTWpVeE5EQTVOVGxhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURoTlBETXBmb0JCRitjOS9HSldLV21NYXp2K0UwRGxodVR5U3hxZVRQNXJWVGk2amp4a3JuOVE4dWMKTHhWOC83L1BiaEtWU3RTTlduNndSQmE3aGhBb3R0aldyRjJLZWlRaUZiVlBwSUxPRmp4YmMrQTJyTnNBYllCSgpKRUQrT2FiMVZxRzVPRlkrMXh6S1VlQ2JXc1hybVFSVWM1UHM4VU5QNnhCZHlIN3dkRXJ2UWJ3NHpReFExTTdpCkh1bTJRVWU4MnhralNTSjFVb24wWTROUEVncndEMytrd1Zna0dsakgzaTdoV1hlZURTTjhjY1BGZHFJSnRxR1AKMDFPVTM4VzNCbmsxZGUybjU4YUJJd2V2RVkvOGpFLzkxVWs2VlFlaWxjMGpsQjlESVFhbCtNbVhyd2hYTHJHWApTS1FVcCt0NmMydU1FTjAydEJkSlgwNnk1UVpoQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTVWZCbTZ5SkFKUExtcDlqV0ZScVNhdXl2ZnFqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2pUQndxaWZ5VgprQzB1dTMrR0N6WWFER01iN0ltbjk3Zy9UR1pEODBPaVZuazMyZGtLMm8xZlNmZ3E3RUE3SjBPS25jMEVSdGw5CjNLckVhT0FxZUxoa1h2YjhyYXZGTG1lb3EvOVZ3Q2o1NUlqWjZHSEcrUCs1UEpwSExOOTlBN1hxcXNBclN0U0cKNE1ubXlvZ1dodm4vQjJUajU5QVRoa1EreUYzcDVZeTVNOWxDVVRmTWx1YW1CK0lLZUFWUUE4WkphNm5ObklwZgpkQTd5ZkdZV1R0UkNMb2lRd2xYcGJWNzZTWHM5bnd5MkJNejJ4d3N6UFdha09MQnBwc2lZakExRFZ3ZFVjSUsxCisrc05iT0JXUVhCVGdMQldXTWRPMEJ3aTJsQjhyd2lTZ3NHRjRlTVR3Q3lNSVJWMzZuQ1czcVljNVVYUHR2NUgKL2VidGI0TGd6MDQ0Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

# Domínio base para Ingress
base_domain = "mixnarede.com.br"

# Let's Encrypt - prod ou staging
cert_manager_letsencrypt_server = "prod"

# Configurações do Prometheus
prometheus_namespace        = "monitoring"
prometheus_create_namespace = true
prometheus_chart_version    = "45.27.2" # Versão compatível com o Prometheus
prometheus_service_type     = "ClusterIP"
prometheus_enable_https     = true
prometheus_create_ingress   = true

# Configurações avançadas do Prometheus
prometheus_retention                 = "15d"
prometheus_resources_requests_cpu    = "500m"
prometheus_resources_requests_memory = "1Gi"
prometheus_resources_limits_cpu      = "1000m"
prometheus_resources_limits_memory   = "2Gi"
prometheus_storage_size              = "10Gi"
grafana_storage_size                 = "5Gi"
grafana_admin_password               = "admin" # Altere isso em produção!

# Configuração da classe de armazenamento
storage_class_name = "gp2"
