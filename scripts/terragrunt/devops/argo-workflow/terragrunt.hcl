
dependency "vault_basement" {
  config_path = "../vault_basement"
}

inputs = {
  secrets_engine_path = dependency.vault_basement.outputs.secrets_engine_path
}

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
      version = "1.2.0"
    }
  }
}
EOF
}