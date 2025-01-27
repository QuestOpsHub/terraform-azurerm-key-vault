#---------------
# Random String
#---------------
module "random_string" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-random-string.git?ref=v1.0.0"

  length  = 4
  lower   = true
  numeric = true
  special = false
  upper   = false
}

#----------------
# Resource Group
#----------------
module "resource_group" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-resource-group.git?ref=v1.0.0"

  name     = "rg-${local.resource_suffix}-${module.random_string.result}"
  location = "centralus"
  tags     = merge(local.resource_tags, local.timestamp_tag)
}

#-----------
# Key Vault
#-----------
module "key_vault" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-key-vault.git//keyVault?ref=v1.0.0"

  name                = lower(replace("kv-${local.resource_suffix}-${module.random_string.result}", "/[[:^alnum:]]/", ""))
  resource_group_name = module.resource_group.name
  location            = "centralus"
  sku_name            = "standard"
  access_policy = {
    # hub_service_principal
    hub_service_principal = {
      object_id               = "5ba02742-39b9-4d8a-849f-f3fef9d27294"
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
    }
    # bhadrareddy.origin_gmail.com#EXT#@bhadrareddyorigingmail.onmicrosoft.com
    bhadra = {
      object_id               = "c659b602-0560-47f7-8583-2c46d8e666bd"
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
    }
  }
  network_acls = {
    default_action      = "Allow"
    bypass              = "AzureServices"
    ip_rules            = []
    subnet_details      = {}
    private_link_access = {}
  }
  purge_protection_enabled      = true
  public_network_access_enabled = true
  soft_delete_retention_days    = 90
  tags                          = merge(local.resource_tags, local.timestamp_tag)
}