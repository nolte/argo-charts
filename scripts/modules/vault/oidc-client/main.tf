
variable "realm_id" {
  
}
variable "client_id" {
  
}
variable "name" {
  
}

variable "valid_redirect_uris" {
  type = list(string)
  
}

resource "keycloak_openid_client" "this" {
  realm_id            = var.realm_id
  client_id           = var.client_id

  name                = var.name
  enabled             = true

  access_type         = "CONFIDENTIAL"
  valid_redirect_uris = var.valid_redirect_uris 
  standard_flow_enabled = true
  login_theme = "keycloak"
  
}
#
output "this" {
  value = keycloak_openid_client.this
}