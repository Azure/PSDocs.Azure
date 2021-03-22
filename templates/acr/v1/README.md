# Container Registry

![Template checks](https://img.shields.io/badge/Template-Pass-green?style=flat-square)

Create or update a Container Registry.

## Parameters

Parameter name | Description
-------------- | -----------
registryName   | Required. The name of the container registry.
location       | Optional. The location to deploy the container registry.
registrySku    | Optional. The container registry SKU.
tags           | Optional. Tags to apply to the resource.

### registryName

Required. The name of the container registry.

### location

Optional. The location to deploy the container registry.

- Default value: `[resourceGroup().location]`

### registrySku

Optional. The container registry SKU.

- Default value: `Basic`

- Allowed values: `Basic`, `Standard`, `Premium`

### tags

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
