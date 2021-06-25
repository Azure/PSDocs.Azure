# Using metadata

PSDocs for Azure extracts meaningful information from Azure IaC artifacts.
This information can be further supplemented with metadata that adds context such as parameter descriptions.

## Annotate template files

In its simplest structure, an Azure template has the following elements:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {  },
  "variables": {  },
  "functions": [  ],
  "resources": [  ],
  "outputs": {  }
}
```

Additionally a `metadata` property can be added in most places throughout the template.
For example:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "name": "Storage Account",
        "description": "Create or update a Storage Account."
    },
    "parameters": {
        "storageAccountName": {
            "type": "string",
            "metadata": {
                "description": "The name of the Storage Account."
            }
        },
        "tags": {
            "type": "object",
            "metadata": {
                "description": "Tags to apply to the resource.",
                "example": {
                    "service": "<service_name>",
                    "env": "prod"
                }
            }
        }
    },
    "resources": [
    ],
    "outputs": {
        "resourceId": {
            "type": "string",
            "value": "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]",
            "metadata": {
                "description": "A unique resource identifier for the storage account."
            }
        }
    }
}
```

This metadata and the template structure itself can be used to dynamically generate documentation.
Documenting templates in this way allows you to:

- Include meaningful information with minimal effort.
- Use DevOps culture to author infrastructure code and documentation side-by-side.
  - Review pull requests (PR) with changes and documentation together.
  - Use continuous integration and deployment to release changes.
- Keep documentation up-to-date.
No separate wiki or document to keep in sync.

PSDocs interprets the template structure and metadata to generate documentation as markdown.
Generating documentation as markdown allows you to publish web-based content on a variety of platforms.

PSDocs supports the following metadata:

Field         | Scope     | Type | Description
-----         | -----     | ---- | -----------
`name`        | Template  | `string` | Used for markdown page title.
`summary`     | Template  | `string` | Used as a short description for the markdown page.
`description` | Template  | `string` | Used as a detailed description for the markdown page.
`description` | Parameter | `string` | Used as the description for the parameter.
`example`     | Parameter | `string`, `boolean`, `object`, or `array` | An example use of the parameter. The example is included in the JSON snippet. If an example is not included the default value is used instead.
`ignore`      | Parameter | `boolean` | When `true` the parameter is not included in the JSON snippet.
`description` | Output    | `string`  | Used as the description for the output.

An example of an Azure Storage Account template with metadata included is available [here][source-template].

### Template metadata

### Parameter metadata

### Output metadata
