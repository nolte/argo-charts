#include {
#  path = find_in_parent_folders()
#}

generate "versions" {
  path      = "versions_override.gen.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "0.14.6"
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.4.0"
    }
  }
}
EOF
}