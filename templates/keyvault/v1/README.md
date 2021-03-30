# Key Vault

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

Create or update a Key Vault.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
vaultName      | Yes      | The name of the Key Vault.
location       | No       | The Azure region to deploy to.
accessPolicies | No       | The access policies defined for this vault.
useDeployment  | No       | Determines if Azure can deploy certificates from this Key Vault.
useTemplate    | No       | Determines if templates can reference secrets from this Key Vault.
useDiskEncryption | No       | Determines if this Key Vault can be used for Azure Disk Encryption.
useSoftDelete  | No       | Determine if soft delete is enabled on this Key Vault.
usePurgeProtection | No       | Determine if purge protection is enabled on this Key Vault.
networkAcls    | No       | The network firewall defined for this vault.
workspaceId    | No       | The workspace to store audit logs.
tags           | Yes      | Tags to apply to the resource.

### vaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the Key Vault.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure region to deploy to.

- Default value: `[resourceGroup().location]`

### accessPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The access policies defined for this vault.

### useDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Determines if Azure can deploy certificates from this Key Vault.

- Default value: `False`

### useTemplate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Determines if templates can reference secrets from this Key Vault.

- Default value: `False`

### useDiskEncryption

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Determines if this Key Vault can be used for Azure Disk Encryption.

- Default value: `False`

### useSoftDelete

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Determine if soft delete is enabled on this Key Vault.

- Default value: `True`

### usePurgeProtection

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Determine if purge protection is enabled on this Key Vault.

- Default value: `True`

### networkAcls

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The network firewall defined for this vault.

- Default value: `@{defaultAction=Allow; bypass=AzureServices; ipRules=System.Object[]; virtualNetworkRules=System.Object[]}`

### workspaceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The workspace to store audit logs.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Tags to apply to the resource.

## Outputs

Name | Type | Description
---- | ---- | -----------
resourceId | string | A unique resource identifier for the Key Vault.

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
