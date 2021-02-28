data "keycloak_realm" "this" {
    realm = var.realm_name
}

module "oidc_client" {
    source = "../../modules/vault/oidc-client"
    realm_id = data.keycloak_realm.this.id
    client_id = "vault"
    name = "vault"
    valid_redirect_uris = [
        "http://localhost:8250/oidc/callback",
        "https://vault.172-17-0-1.sslip.io/ui/vault/auth/oidc/oidc/callback",
    ]
}

data "kubernetes_secret" "keycloak_cert" {
  metadata {
    name = "keycloak-cert-tls"
    namespace = "keycloak"
  }
}

resource "vault_jwt_auth_backend" "this" {
    description  = "keycloak OIDC Auth Backend"
    path = "oidc"
    type = "oidc"
    oidc_client_id = module.oidc_client.this.client_id
    oidc_client_secret = module.oidc_client.this.client_secret
    oidc_discovery_url = "https://keycloak.172-17-0-1.sslip.io/auth/realms/master"
    oidc_discovery_ca_pem = data.kubernetes_secret.keycloak_cert.data["ca.crt"]
    default_role = "demo"
}

resource "vault_jwt_auth_backend_role" "this" {
  backend         = vault_jwt_auth_backend.this.path
  role_name       = "demo"
  #token_policies  = ["default", "dev", "prod"]
  allowed_redirect_uris = [
    "http://localhost:8250/oidc/callback",
    "https://vault.172-17-0-1.sslip.io/ui/vault/auth/oidc/oidc/callback"
  ]
  groups_claim = "groups"
  user_claim = "email"
  token_policies = ["default"]
  #bound_audiences = ["https://myco.test"]
  #user_claim      = "https://vault/user"
  #role_type       = "jwt"
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "user_realm_role_mapper" {
    realm_id    = data.keycloak_realm.this.id
    client_id   = module.oidc_client.this.id
    name        = "groups"

    claim_name  = "groups"
}