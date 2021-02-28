variable "secrets_engine_path" {
}

variable "vault_bound_service_account_names" {
 default = [
   "internal-app",
   "argo",
   "argocd-server",
 ]
}
variable "vault_bound_service_account_namespaces" {
 default = [
   "*",
 ]
}