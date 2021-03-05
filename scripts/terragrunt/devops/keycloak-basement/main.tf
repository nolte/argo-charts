data "keycloak_realm" "this" {
    realm = var.realm_name
}

resource "keycloak_role" "admins" {
  realm_id    = data.keycloak_realm.this.id
  name        = "admins-role"
  description = "My Realm admins Role"
}

resource "keycloak_role" "users" {
  realm_id    = data.keycloak_realm.this.id
  name        = "users-role"
  description = "My Realm users Role"
}

resource "keycloak_user" "admin" {
  realm_id = data.keycloak_realm.this.id
  username = "nolte"
  enabled  = true

  email      = "bob@domain.com"
  first_name = "Bob"
  last_name  = "Bobson"
}

resource "keycloak_user_roles" "admin_roles" {
  realm_id = data.keycloak_realm.this.id
  user_id  = keycloak_user.admin.id

  role_ids = [
    keycloak_role.admins.id,
    keycloak_role.users.id,
  ]
}

resource "keycloak_user" "user" {
  realm_id = data.keycloak_realm.this.id
  username = "jondo"
  enabled  = true

  email      = "jondo@domain.com"
  first_name = "Bob"
  last_name  = "Bobson"
}

resource "keycloak_user_roles" "user_roles" {
  realm_id = data.keycloak_realm.this.id
  user_id  = keycloak_user.user.id

  role_ids = [
    keycloak_role.users.id,
  ]
}

