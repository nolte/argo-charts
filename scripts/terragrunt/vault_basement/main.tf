# https://www.vaultproject.io/docs/auth/kubernetes
variable "secrets_engine_path" {
  default = "internal"
}

module "secrets_engine" {
  source = "github.com/nolte/terraform-vault-secrets-engine.git?ref=9eb551ee001924de184a35a385fcc7a7973dce41"

  path = "internal"
  type = "kv"
  options = {
    version = 2
  }
}

output "secrets_engine_path" {
  value = module.secrets_engine.path
}
