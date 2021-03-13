# Storage Account

Create or update a Storage Account.

This template deploys a Storage Account including blob containers and files shares. Encryption in transit it enabled using a minimum of TLS 1.2.

## Parameters

Parameter name | Description
-------------- | -----------
storageAccountName | Required. The name of the Storage Account.
location       | Optional. The Azure region to deploy to.
sku            | Optional. Create the Storage Account as LRS or GRS.
suffixLength   | Optional. Determine how many additional characters are added to the storage account name as a suffix.
containers     | Optional. An array of storage containers to create on the storage account.
lifecycleRules | Optional. An array of lifecycle management policies for the storage account.
blobSoftDeleteDays | Optional. The number of days to retain deleted blobs. When set to 0, soft delete is disabled.
containerSoftDeleteDays | Optional. The number of days to retain deleted containers. When set to 0, soft delete is disabled.
shares         | Optional. An array of file shares to create on the storage account.
useLargeFileShares | Optional. Determines if large file shares are enabled. This can not be disabled once enabled.
shareSoftDeleteDays | Optional. The number of days to retain deleted shares. When set to 0, soft delete is disabled.
allowBlobPublicAccess | Optional. Determines if any containers can be configured with the anonymous access types of blob or container.
keyVaultPrincipalId | Optional. Set to the objectId of Azure Key Vault to delegated permission for use with Key Managed Storage Accounts.
tags           | Optional. Tags to apply to the resource.

### storageAccountName

Required. The name of the Storage Account.

### location

Optional. The Azure region to deploy to.

- Default value: `[resourceGroup().location]`

### sku

Optional. Create the Storage Account as LRS or GRS.

- Default value: `Standard_LRS`

- Allowed values: `Standard_LRS`, `Standard_GRS`

### suffixLength

Optional. Determine how many additional characters are added to the storage account name as a suffix.

- Default value: `0`

### containers

Optional. An array of storage containers to create on the storage account.

### lifecycleRules

Optional. An array of lifecycle management policies for the storage account.

### blobSoftDeleteDays

Optional. The number of days to retain deleted blobs. When set to 0, soft delete is disabled.

- Default value: `0`

### containerSoftDeleteDays

Optional. The number of days to retain deleted containers. When set to 0, soft delete is disabled.

- Default value: `0`

### shares

Optional. An array of file shares to create on the storage account.

### useLargeFileShares

Optional. Determines if large file shares are enabled. This can not be disabled once enabled.

- Default value: `False`

### shareSoftDeleteDays

Optional. The number of days to retain deleted shares. When set to 0, soft delete is disabled.

- Default value: `0`

### allowBlobPublicAccess

Optional. Determines if any containers can be configured with the anonymous access types of blob or container.

- Default value: `False`

### keyVaultPrincipalId

Optional. Set to the objectId of Azure Key Vault to delegated permission for use with Key Managed Storage Accounts.

### tags

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
