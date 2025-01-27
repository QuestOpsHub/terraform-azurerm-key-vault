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
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-key-vault.git?ref=v1.0.0"

  name                = lower(replace("kv-${local.resource_suffix}-${module.random_string.result}", "/[[:^alnum:]]/", ""))
  resource_group_name = module.resource_group.name
  location            = "centralus"
  sku_name            = "standard"
  access_policy = {
    alpha = {
      object_id               = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
    },
    beta = {
      object_id               = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
    }
  }
  network_acls = {
    default_action = "Allow"
    bypass         = "AzureServices"
    ip_rules       = []
    subnet_details = {
      default = {
        vnet_rg_name = "rg-qoh-cus"
        vnet_name    = "vnet-qoh-cus"
        subnet_name  = "default"
      }
    }
    private_link_access = {}
  }
  purge_protection_enabled      = true
  public_network_access_enabled = true
  soft_delete_retention_days    = 90
  tags                          = merge(local.resource_tags, local.timestamp_tag)
}