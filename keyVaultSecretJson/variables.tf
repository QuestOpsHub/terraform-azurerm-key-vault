#------------------
# Key Vault Secret
#------------------
variable "kvsecrets" {
  description = "(Required) Key Vault Secrets"
  type        = any
}

variable "key_vault_id" {
  description = "(Required) The ID of the Key Vault where the Secret should be created. Changing this forces a new resource to be created."
  type        = string
}