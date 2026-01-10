### JSON secrets file

- Save the following JSON file at `/` path on the runner.

- `cd /azure-keyvault-secrets/hub-keyvault-secrets` on `vm-jumpbox-hub-dev-cus`
```
{
  "kv": [
    {
      "name": "username",
      "value": "********"
    }
  ]
}
```

### Deployment

```
module "key_vault_secret" {
  source = "git::https://github.com/QuestOpsHub/QuestOpsHub-terraform-azure-modules.git//keyVaultSecret?ref=main"

  for_each     = var.key_vault_secret
  kvsecrets    = each.value.kvsecrets
  key_vault_id = module.key_vault[each.value.key_vault].id
}
```

```
key_vault_secret = {
  hub = {
    kvsecrets = {
      file_path = "/azure-keyvault-secrets/hub-keyvault-secrets/secrets.json"
      file_name = "secrets.json"
    }
    key_vault = "kv"
  }
}
```