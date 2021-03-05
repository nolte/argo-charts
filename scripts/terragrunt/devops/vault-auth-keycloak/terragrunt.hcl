
include {
  path = find_in_parent_folders()
}


dependency "keycloak_basement" {
  config_path = "../keycloak-basement"
}

inputs = {
  realm_name = dependency.keycloak_basement.outputs.realm_name
}


generate "versions" {
  path      = "versions_override.gen.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "0.14.6"
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = "2.2.0"
    }
  }
}
EOF
}