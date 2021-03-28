# Key Vault

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

Create or update a Key Vault.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
vaultName      | Yes      | Required. The name of the Key Vault.
location       | No       | Optional. The Azure region to deploy to.
accessPolicies | No       | Optional. The access policies defined for this vault.
useDeployment  | No       | Optional. Determines if Azure can deploy certificates from this Key Vault.
useTemplate    | No       | Optional. Determines if templates can reference secrets from this Key Vault.
useDiskEncryption | No       | Optional. Determines if this Key Vault can be used for Azure Disk Encryption.
useSoftDelete  | No       | Optional. Determine if soft delete is enabled on this Key Vault.
usePurgeProtection | No       | Optional. Determine if purge protection is enabled on this Key Vault.
networkAcls    | No       | Optional. The network firewall defined for this vault.
workspaceId    | No       | Optional. The workspace to store audit logs.
tags           | No       | Optional. Tags to apply to the resource.

### vaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the Key Vault.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure region to deploy to.

- Default value: `[resourceGroup().location]`

### accessPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The access policies defined for this vault.

### useDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determines if Azure can deploy certificates from this Key Vault.

- Default value: `False`

### useTemplate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determines if templates can reference secrets from this Key Vault.

- Default value: `False`

### useDiskEncryption

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determines if this Key Vault can be used for Azure Disk Encryption.

- Default value: `False`

### useSoftDelete

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determine if soft delete is enabled on this Key Vault.

- Default value: `True`

### usePurgeProtection

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determine if purge protection is enabled on this Key Vault.

- Default value: `True`

### networkAcls

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The network firewall defined for this vault.

- Default value: `@{defaultAction=Allow; bypass=AzureServices; ipRules=System.Object[]; virtualNetworkRules=System.Object[]}`

### workspaceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The workspace to store audit logs.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags to apply to the resource.

## Outputs

Name | Type | Description
---- | ---- | -----------
resourceId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "templates/keyvault/v1/template.json"
    },
    "parameters": {
        "vaultName": {
            "value": "<name>"
        },
        "accessPolicies": {
            "value": [
                {
                    "objectId": "<object_id>",
                    "tenantId": "<tenant_id>",
                    "permissions": {
                        "secrets": [
                            "Get",
                            "List",
                            "Set"
                        ]
                    }
                }
            ]
        },
        "useDeployment": {
            "value": false
        },
        "useTemplate": {
            "value": false
        },
        "useDiskEncryption": {
            "value": false
        },
        "networkAcls": {
            "value": {
                "defaultAction": "Allow",
                "bypass": "AzureServices",
                "ipRules": [],
                "virtualNetworkRules": []
            }
        },
        "workspaceId": {
            "value": "<resource_id>"
        },
        "tags": {
            "value": {
                "service": "<service_name>",
                "env": "prod"
            }
        }
    }
}
```
