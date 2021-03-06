# https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar
data "kubernetes_namespace" "this" {
  metadata {
    name = "vault"
  }
}

data "kubernetes_service_account" "this" {
  metadata {
    name = "vault"
    namespace = data.kubernetes_namespace.this.metadata.0.name
  }
}

data "kubernetes_secret" "this" {
  metadata {
    name      = data.kubernetes_service_account.this.default_secret_name
    namespace = data.kubernetes_service_account.this.metadata.0.namespace
  }
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  local = false
  tune {
    max_lease_ttl      = "90000s"
    default_lease_ttl = "30000s"
    token_type = "default-service"
  }
}

data "kubernetes_service" "example" {
  metadata {
    name = "kubernetes"
  }
}

resource "vault_kubernetes_auth_backend_config" "example" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = format("https://%s:443",data.kubernetes_service.example.spec.0.cluster_ip) #"https://kubernetes.svc:443"
  kubernetes_ca_cert     = data.kubernetes_secret.this.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.this.data["token"]
  #issuer                 = "api"
  #disable_iss_validation = "true"
}


resource "vault_policy" "this" {
  name = "internal-app"

  policy = <<EOT
path "${format("%s/data/database/config",var.secrets_engine_path)}" {
  capabilities = ["read"]
}
EOT
}


resource "vault_kubernetes_auth_backend_role" "example" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = vault_policy.this.name
  bound_service_account_names      = var.vault_bound_service_account_names #[kubernetes_service_account.vault_auth.metadata.0.name]
  bound_service_account_namespaces = var.vault_bound_service_account_namespaces #[kubernetes_service_account.vault_auth.metadata.0.namespace]
  token_ttl                        = 3600 * 60 * 24
  token_policies                   = ["default","internal-app"]
  #audience                         = "vault"
}