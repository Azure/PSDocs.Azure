# Container Registry

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

Create or update a Container Registry.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
registryName   | Yes      | Required. The name of the container registry.
location       | No       | Optional. The location to deploy the container registry.
registrySku    | No       | Optional. The container registry SKU.
tags           | No       | Optional. Tags to apply to the resource.

### registryName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the container registry.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The location to deploy the container registry.

- Default value: `[resourceGroup().location]`

### registrySku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The container registry SKU.

- Default value: `Basic`

- Allowed values: `Basic`, `Standard`, `Premium`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags to apply to the resource.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "templates/acr/v1/template.json"
    },
    "parameters": {
        "registryName": {
            "value": "<name>"
        },
        "registrySku": {
            "value": "Basic"
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
