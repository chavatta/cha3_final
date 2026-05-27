variable "aws_region" {
  type        = string
  description = "Região AWS."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Nome do ambiente (ex: dev, hml, prod)."
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Prefixo de recursos."
  default     = "togglemaster"
}

# --- AWS Academy (Opção A): não criar IAM; usar LabRole existente ---
variable "use_lab_role" {
  type        = bool
  description = "true = usar LabRole da AWS Academy para EKS (sem criar roles IAM)."
  default     = true
}

variable "lab_role_name" {
  type        = string
  description = "Nome da role fornecida pelo laboratório (geralmente LabRole)."
  default     = "LabRole"
}

# --- Opção B: roles customizadas (use_lab_role = false) ---
variable "eks_cluster_role_arn" {
  type        = string
  description = "ARN da role do cluster EKS (obrigatório se use_lab_role = false)."
  default     = ""
}

variable "eks_node_role_arn" {
  type        = string
  description = "ARN da role dos nodes (obrigatório se use_lab_role = false)."
  default     = ""
}

variable "eks_cluster_version" {
  type        = string
  description = "Versão do Kubernetes no EKS."
  default     = "1.34"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Tipos de instância do Node Group."
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "db_username" {
  type        = string
  description = "Usuário master dos RDS PostgreSQL."
  default     = "toggleadmin"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Senha master dos RDS (use secrets manager em produção). Não pode conter: / @ \" ou espaço."
  sensitive   = true

  validation {
    condition     = !can(regex("[/@\" ]", var.db_password))
    error_message = "db_password não pode conter os caracteres '/', '@', '\"' ou espaço (restrição do RDS)."
  }
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "enable_argocd" {
  type        = bool
  description = "Instalar ArgoCD via Helm após o cluster existir."
  default     = true
}

variable "argo_password" {
  type        = string
  description = "Senha do admin do ArgoCD (bcrypt hash gerado automaticamente)."
  sensitive   = true
  default     = ""
}

variable "ecr_repositories" {
  type        = list(string)
  description = "Nomes dos repositórios ECR (5 microsserviços)."
  default = [
    "togglemaster-auth",
    "togglemaster-flag",
    "togglemaster-targeting",
    "togglemaster-evaluation",
    "togglemaster-analytics",
  ]
}

variable "rds_databases" {
  type        = list(string)
  description = "Identificadores lógicos das 3 instâncias RDS."
  default     = ["auth", "flag", "targeting"]
}

variable "master_key" {
  type        = string
  description = "Chave mestre para o serviço de autenticação."
  default     = "admin-secreto-123"
  sensitive   = true
}

variable "service_api_key" {
  type        = string
  description = "API key usada pelo evaluation service para comunicação interna."
  default     = "default-service-key"
  sensitive   = true
}
