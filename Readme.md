# Azure Key Vault Terraform Module

Terraform module to create a Key Vault.

# Table of Contents

- [Azure Resource Naming Convention](#azure-resource-naming-convention)
    - [Format](#Format)
    - [Components](#Components)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Azure Resource Naming Convention

Resource names should clearly indicate their type, workload, environment, and region. Using a consistent naming convention ensures clarity, uniformity, and easy identification across all repositories.

#### Format

```
<resource_prefix>-<app_or_project>-<environment>-<region>-<optional_unique_suffix>
```

#### Components

| **Component**           | **Description**                                                                      | **Example**             |
|--------------------------|--------------------------------------------------------------------------------------|-------------------------|
| `resource_prefix`        | Short abbreviation for the resource type.                                           | `rg` (Resource Group)   |
| `app_or_project`         | Identifier for the application or project.                                          | `qoh`           |
| `environment`            | Environment where the resource is deployed (`prod`, `dev`, `test`, etc.).           | `prod`                 |
| `region`                 | Azure region where the resource resides (e.g., `cus` for `centralus`).              | `cus`                  |
| `optional_unique_suffix` | Optional unique string for ensuring name uniqueness, often random or incremental.    | `abcd`, `a42n`                 |

## Network ACLs Configuration

#### Service Endpoints

- Before adding the network_acls block, ensure that service endpoints are configured for the subnet. This is required for proper integration with Azure Key Vault.

```hcl
service_endpoints = ["Microsoft.KeyVault"]
```

```hcl
network_acls = {
  default_action = "Deny"
  bypass         = "AzureServices"  # Must be a string, not a list
  ip_rules       = []               # No specific IPs allowed
  subnet_details = {
    default = {
      vnet_rg_name = module.virtual_network["network"].resource_group_name
      vnet_name    = module.virtual_network["network"].name
      subnet_name  = module.virtual_network["network"].subnets["default"].name
    }
  }
  private_link_access = {}  # No private link access configured
}
```