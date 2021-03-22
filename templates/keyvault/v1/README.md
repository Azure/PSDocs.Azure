# Key Vault

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

Create or update a Key Vault.

## Parameters

Parameter name | Description
-------------- | -----------
vaultName      | Required. The name of the Key Vault.
location       | Optional. The Azure region to deploy to.
accessPolicies | Optional. The access policies defined for this vault.
useDeployment  | Optional. Determines if Azure can deploy certificates from this Key Vault.
useTemplate    | Optional. Determines if templates can reference secrets from this Key Vault.
useDiskEncryption | Optional. Determines if this Key Vault can be used for Azure Disk Encryption.
useSoftDelete  | Optional. Determine if soft delete is enabled on this Key Vault.
usePurgeProtection | Optional. Determine if purge protection is enabled on this Key Vault.
networkAcls    | Optional. The network firewall defined for this vault.
workspaceId    | Optional. The workspace to store audit logs.
tags           | Optional. Tags to apply to the resource.

### vaultName

Required. The name of the Key Vault.

### location

Optional. The Azure region to deploy to.

- Default value: `[resourceGroup().location]`

### accessPolicies

Optional. The access policies defined for this vault.

### useDeployment

Optional. Determines if Azure can deploy certificates from this Key Vault.

- Default value: `False`

### useTemplate

Optional. Determines if templates can reference secrets from this Key Vault.

- Default value: `False`

### useDiskEncryption

Optional. Determines if this Key Vault can be used for Azure Disk Encryption.

- Default value: `False`

### useSoftDelete

Optional. Determine if soft delete is enabled on this Key Vault.

- Default value: `True`

### usePurgeProtection

Optional. Determine if purge protection is enabled on this Key Vault.

- Default value: `True`

### networkAcls

Optional. The network firewall defined for this vault.

- Default value: `@{defaultAction=Allow; bypass=AzureServices; ipRules=System.Object[]; virtualNetworkRules=System.Object[]}`

### workspaceId

Optional. The workspace to store audit logs.

### tags

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
