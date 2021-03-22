---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
title: Home
nav_order: 1
permalink: /
---

# Git it done
{: .fs-9 }

Focus on building great solutions on Azure instead of writing documentation.
PSDocs for Azure automatically generates documentation for Azure infrastructure as code (IaC) artifacts.
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/Azure/PSDocs.Azure){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## Getting started

### Annotate templates file

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
                "description": "Required. The name of the Storage Account."
            }
        },
        "tags": {
            "type": "object",
            "defaultValue": {
            },
            "metadata": {
                "description": "Optional. Tags to apply to the resource.",
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

PSDocs interprets the template structure and metadata to generate documentation as markdown.
Generating documentation as markdown allows you to publish web-based content on a variety of platforms.

PSDocs supports the following metadata:

Field | Scope | Type | Description
----- | ----- | ---- | -----------
`name`  | Template | `string` | Used for markdown page title.
`description` | Template | `string` | Used as the top description for the markdown page.
`description` | Parameter | `string` | Used as the description for the parameter.
`example`     | Parameter | `string`, `boolean`, `object`, or `array` | An example use of the parameter. The example is included in the JSON snippet. If an example is not included the default value is used instead.
`ignore`      | Parameter | `boolean` | When `true` the parameter is not included in the JSON snippet.
`description` | Output    | `string`  | Used as the description for the output.

### Using with GitHub Actions

The following example shows how to setup GitHub Actions to copy generated markdown files to an Azure blob storage account.

- See [Creating a workflow file][create-workflow] to create an empty workflow file.
- Add a PowerShell step to:
  - Install [PSDocs.Azure][module] module.
  - Scan for Azure template file recursively in the templates/ directory.
  - Generate a standard name of the markdown file. i.e. `<name>_<version>`.md
  - Generate the markdown to a specific directory.
- Set the `STORAGEACCOUNTSECRET` action secret.
- Use an [Azure Blob Storage Upload action](https://github.com/marketplace/actions/azure-blob-storage-upload) to copy the generated markdown to an Azure Storage Blob container.

For example:

```yaml
# Example: .github/workflows/arm-docs.yaml

name: Generate ARM templates docs
on:
  push:
    branches: [ main ]
jobs:
  arm_docs:
    name: Generate ARM template docs
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    # STEP 1: Generate Markdowns using PSDocs
    - name: Generate ARM markdowns
      run: | 
        Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -force;
        # Scan for Azure template file recursively in the templates/ directory
        Get-AzDocTemplateFile -Path templates/ | ForEach-Object {
          # Generate a standard name of the markdown file. i.e. <name>_<version>.md
          $template = Get-Item -Path $_.TemplateFile;
          $templateName = $template.Directory.Parent.Name;
          $version = $template.Directory.Name;
          $docName = "$($templateName)_$version";
          # Generate markdown
          Invoke-PSDocument -Module PSDocs.Azure -OutputPath out/docs/ -InputObject $template.FullName -InstanceName $docName;
        }
      shell: pwsh

    # STEP 2: Copy files to a storage account
    - name: Copy files to a storage account
      uses: bacongobbler/azure-blob-storage-upload@v1.1.1
      with:
        connection_string: ${{ secrets.STORAGEACCOUNTSECRET }}
        container_name: ps-docs
        source_dir: 'out/docs/*'
```

### Using with Azure Pipelines

The following example shows how to setup Azure Pipelines to generate ARM template documentation in the markdown format.
This example copies the generated markdown files to a designated blob storage.

- Create a new YAML pipeline with the Starter pipeline template.
- Add a PowerShell task to:
  - Install [PSDocs.Azure][module] module.
  - Scan for Azure template file recursively in the templates/ directory.
  - Generate a standard name of the markdown file. i.e. `<name>_<version>`.md
  - Generate the markdown to a specific directory.
- Add an [AzureFileCopy task](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-file-copy?view=azure-devops) to copy the generated markdown to an Azure Storage Blob container.

For example:

```yaml
# Example: .azure-pipelines/psdocs-blobstorage.yaml

jobs:
- job: 'generate_arm_template_documentation'
  displayName: 'Generate ARM template docs'
  pool:
    vmImage: 'windows-2019'
  steps:
  # STEP 1: Generate Markdowns using PSDocs
  - powershell: | 
      Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -force;
        # Scan for Azure template file recursively in the templates/ directory
        Get-AzDocTemplateFile -Path templates/ | ForEach-Object {
        # Generate a standard name of the markdown file. i.e. <name>_<version>.md
        $template = Get-Item -Path $_.TemplateFile;
        $templateName = $template.Directory.Parent.Name;
        $version = $template.Directory.Name;
        $docName = "$($templateName)_$version";
        # Generate markdown
        Invoke-PSDocument -Module PSDocs.Azure -OutputPath out/docs/ -InputObject $template.FullName -InstanceName $docName;
      }
    displayName: 'Export template data'
    
  # STEP 2: Copy files to a storage account
  - task: AzureFileCopy@4
    displayName: 'Copy files to a storage account blob container'
    inputs:
      SourcePath: 'out/docs/*'
      azureSubscription: 'psdocstest'
      Destination: 'AzureBlob'
      storage: '<storageaccountname>' 
      ContainerName: 'ps-docs'
```

[create-workflow]: https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file
[module]: https://www.powershellgallery.com/packages/PSDocs.Azure
