# Storage Account

Create or update a Storage Account.

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

This template deploys a Storage Account including blob containers and files shares. Encryption in transit it enabled using a minimum of TLS 1.2.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
name           | Yes      | The name of the storage account.
location       | No       | The location of the storage account.

### name

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the storage account.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The location of the storage account.

**Default value**

```text
[resourceGroup().location]
```

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "examples/bicep/storage/v1/main.json"
    },
    "parameters": {
        "name": {
            "value": ""
        }
    }
}
```
