# Storage Account

Create or update a Storage Account.

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

This template deploys a Storage Account including blob containers and files shares. Encryption in transit it enabled using a minimum of TLS 1.2.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
storageAccountName | Yes      | Required. The name of the Storage Account.
location       | No       | Optional. The Azure region to deploy to.
sku            | No       | Optional. Create the Storage Account as LRS or GRS.
suffixLength   | No       | Optional. Determine how many additional characters are added to the storage account name as a suffix.
containers     | No       | Optional. An array of storage containers to create on the storage account.
lifecycleRules | No       | Optional. An array of lifecycle management policies for the storage account.
blobSoftDeleteDays | No       | Optional. The number of days to retain deleted blobs. When set to 0, soft delete is disabled.
containerSoftDeleteDays | No       | Optional. The number of days to retain deleted containers. When set to 0, soft delete is disabled.
shares         | No       | Optional. An array of file shares to create on the storage account.
useLargeFileShares | No       | Optional. Determines if large file shares are enabled. This can not be disabled once enabled.
shareSoftDeleteDays | No       | Optional. The number of days to retain deleted shares. When set to 0, soft delete is disabled.
allowBlobPublicAccess | No       | Optional. Determines if any containers can be configured with the anonymous access types of blob or container.
keyVaultPrincipalId | No       | Optional. Set to the objectId of Azure Key Vault to delegated permission for use with Key Managed Storage Accounts.
tags           | No       | Optional. Tags to apply to the resource.

### storageAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the Storage Account.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure region to deploy to.

- Default value: `[resourceGroup().location]`

### sku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Create the Storage Account as LRS or GRS.

- Default value: `Standard_LRS`

- Allowed values: `Standard_LRS`, `Standard_GRS`

### suffixLength

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determine how many additional characters are added to the storage account name as a suffix.

- Default value: `0`

### containers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. An array of storage containers to create on the storage account.

### lifecycleRules

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. An array of lifecycle management policies for the storage account.

### blobSoftDeleteDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The number of days to retain deleted blobs. When set to 0, soft delete is disabled.

- Default value: `0`

### containerSoftDeleteDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The number of days to retain deleted containers. When set to 0, soft delete is disabled.

- Default value: `0`

### shares

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. An array of file shares to create on the storage account.

### useLargeFileShares

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determines if large file shares are enabled. This can not be disabled once enabled.

- Default value: `False`

### shareSoftDeleteDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The number of days to retain deleted shares. When set to 0, soft delete is disabled.

- Default value: `0`

### allowBlobPublicAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Determines if any containers can be configured with the anonymous access types of blob or container.

- Default value: `False`

### keyVaultPrincipalId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set to the objectId of Azure Key Vault to delegated permission for use with Key Managed Storage Accounts.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags to apply to the resource.

## Outputs

Name | Type | Description
---- | ---- | -----------
blobEndpoint | string | A URI to the blob storage endpoint.
resourceId | string | A unique resource identifier for the storage account.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "templates/storage/v1/template.json"
    },
    "parameters": {
        "storageAccountName": {
            "value": ""
        },
        "sku": {
            "value": "Standard_LRS"
        },
        "containers": {
            "value": [
                {
                    "name": "logs",
                    "publicAccess": "None",
                    "metadata": {}
                }
            ]
        },
        "lifecycleRules": {
            "value": {
                "enabled": true,
                "name": "<rule_name>",
                "type": "Lifecycle",
                "definition": {
                    "actions": {
                        "baseBlob": {
                            "delete": {
                                "daysAfterModificationGreaterThan": 7
                            }
                        }
                    },
                    "filters": {
                        "blobTypes": [
                            "blockBlob"
                        ],
                        "prefixMatch": [
                            "logs/"
                        ]
                    }
                }
            }
        },
        "blobSoftDeleteDays": {
            "value": 7
        },
        "containerSoftDeleteDays": {
            "value": 7
        },
        "shares": {
            "value": [
                {
                    "name": "<share_name>",
                    "shareQuota": 5,
                    "metadata": {}
                }
            ]
        },
        "shareSoftDeleteDays": {
            "value": 7
        },
        "allowBlobPublicAccess": {
            "value": false
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
