# Key Vault

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

Create or update a Key Vault.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
vaultName      | Required | Required. The name of the Key Vault.
location       | Optional | Optional. The Azure region to deploy to.
accessPolicies | Optional | Optional. The access policies defined for this vault.
useDeployment  | Optional | Optional. Determines if Azure can deploy certificates from this Key Vault.
useTemplate    | Optional | Optional. Determines if templates can reference secrets from this Key Vault.
useDiskEncryption | Optional | Optional. Determines if this Key Vault can be used for Azure Disk Encryption.
useSoftDelete  | Optional | Optional. Determine if soft delete is enabled on this Key Vault.
usePurgeProtection | Optional | Optional. Determine if purge protection is enabled on this Key Vault.
networkAcls    | Optional | Optional. The network firewall defined for this vault.
workspaceId    | Optional | Optional. The workspace to store audit logs.
tags           | Optional | Optional. Tags to apply to the resource.

### vaultName

Required

Required. The name of the Key Vault.

### location

Optional

Optional. The Azure region to deploy to.

- Default value: `[resourceGroup().location]`

### accessPolicies

Optional

Optional. The access policies defined for this vault.

### useDeployment

Optional

Optional. Determines if Azure can deploy certificates from this Key Vault.

- Default value: `False`

### useTemplate

Optional

Optional. Determines if templates can reference secrets from this Key Vault.

- Default value: `False`

### useDiskEncryption

Optional

Optional. Determines if this Key Vault can be used for Azure Disk Encryption.

- Default value: `False`

### useSoftDelete

Optional

Optional. Determine if soft delete is enabled on this Key Vault.

- Default value: `True`

### usePurgeProtection

Optional

Optional. Determine if purge protection is enabled on this Key Vault.

- Default value: `True`

### networkAcls

Optional

Optional. The network firewall defined for this vault.

- Default value: `@{defaultAction=Allow; bypass=AzureServices; ipRules=System.Object[]; virtualNetworkRules=System.Object[]}`

### workspaceId

Optional

Optional. The workspace to store audit logs.

### tags

Optional

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
