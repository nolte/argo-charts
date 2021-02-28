
include {
  path = find_in_parent_folders()
}

generate "versions" {
  path      = "versions_override.gen.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    minio = {
      source = "aminueza/minio"
      version = ">= 1.2.0"
    }
    keycloak = {
      source = "mrparkers/keycloak"
      version = ">= 2.2.0"
    }    
  }
}
EOF
}