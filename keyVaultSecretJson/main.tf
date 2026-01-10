#------------------
# Key Vault Secret
#------------------
locals {
  kv_data = jsondecode(file("${var.kvsecrets.file_path}"))

  kv_secrets = {
    for entry in flatten([
      for kv in try(local.kv_data.kv, []) : [
        {
          secret_name  = kv.name,
          secret_value = kv.value
        }
      ]
    ]) : "${entry.secret_name}-${entry.secret_value}" => entry
  }
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  for_each     = local.kv_secrets
  name         = each.value.secret_name
  value        = each.value.secret_value
  key_vault_id = var.key_vault_id
}