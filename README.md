# PSDocs for Azure

Generate markdown from Azure infrastructure as code (IaC) artifacts.

![ci-badge]

Features of PSDocs for Azure include:

- [Ready to go](docs/features.md#ready-to-go) - Use pre-built templates.
- [DevOps](docs/features.md#devops) - Generate within a continuous integration (CI) pipeline.
- [Cross-platform](docs/features.md#cross-platform) - Run on MacOS, Linux, and Windows.

## Support

This project uses GitHub Issues to track bugs and feature requests.
Please search the existing issues before filing new issues to avoid duplicates.

- For new issues, file your bug or feature request as a new [issue].
- For help, discussion, and support questions about using this project, join or start a [discussion].

If you have any problems with the [PSDocs][engine] engine, please check the project GitHub [issues](https://github.com/BernieWhite/PSDocs/issues) page instead.

Support for this project/ product is limited to the resources listed above.

## Getting the modules

This project requires the `PSDocs` PowerShell module.
For details on each see [install].

You can download and install these modules from the PowerShell Gallery.

Module       | Description | Downloads / instructions
------       | ----------- | ------------------------
PSDocs.Azure | Generate documentation from Azure infrastructure as code (IaC) artifacts. | [latest][module] / [instructions][install]

## Getting started

The follow example uses PSDocs for Azure to generate markdown from an Azure template.
The source template and generated output are provided below.

- [Azure template][source-template]
- [Output markdown][output-template]

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

Field | Scope | Type | Description
----- | ----- | ---- | -----------
`name`  | Template | `string` | Used for markdown page title.
`description` | Template | `string` | Used as the top description for the markdown page.
`description` | Parameter | `string` | Used as the description for the parameter.
`example`     | Parameter | `string`, `boolean`, `object`, or `array` | An example use of the parameter. The example is included in the JSON snippet. If an example is not included the default value is used instead.
`ignore`      | Parameter | `boolean` | When `true` the parameter is not included in the JSON snippet.
`description` | Output    | `string`  | Used as the description for the output.

An example of an Azure Storage Account template with metadata included is available [here][source-template].

### Running locally

To run PSDocs for Azure locally use the `Invoke-PSDocument` cmdlet.

```powershell
# Import module
Import-Module PSDocs.Azure;

# Generate markdown
Invoke-PSDocument -Module PSDocs.Azure -InputObject '<template_file_path>' -OutputPath out/docs/;
```

This will generate a `README.md` in out/docs directory with the generated markdown (also creates out/docs/ directory if it does not exist).

### Scanning for templates

To scan for templates in a directory the `Get-AzDocTemplateFile` cmdlet can be used.

```powershell
# Import module
Import-Module PSDocs.Azure;

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
```

In this example template files are stored in a directory structure such as `templates/<name>/<version>/template.json`.
i.e. `templates/storage/v1/template.json`.

The example finds all the Azure template files and outputs a markdown file for each in `out/docs/`.
An example of the generated markdown is available [here][output-template]

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

## Language reference

PSDocs for Azure extends PowerShell with the following cmdlets and concepts.

### Commands

The following commands exist in the `PSDocs.Azure` module:

- [Get-AzDocTemplateFile](docs/commands/en-US/Get-AzDocTemplateFile.md) - Get Azure template files within a directory structure.

### Concepts

The following conceptual topics exist in the `PSDocs.Azure` module:

- [Badges](docs/concepts/en-US/about_PSDocs_Azure_Badges.md)
- [Configuration](docs/concepts/en-US/about_PSDocs_Azure_Configuration.md)
  - [AZURE_USE_PARAMETER_FILE_SNIPPET](docs/concepts/en-US/about_PSDocs_Azure_Configuration.md#azure_use_parameter_file_snippet)
  - [AZURE_USE_COMMAND_LINE_SNIPPET](docs/concepts/en-US/about_PSDocs_Azure_Configuration.md#azure_use_command_line_snippet)

## Changes and versioning

Modules in this repository will use the [semantic versioning](http://semver.org/) model to declare breaking changes from v1.0.0.
Prior to v1.0.0, breaking changes may be introduced in minor (0.x.0) version increments.
For a list of module changes please see the [change log](CHANGELOG.md).

> Pre-release module versions are created on major commits and can be installed from the PowerShell Gallery.
> Pre-release versions should be considered experimental.
> Modules and change log details for pre-releases will be removed as standard releases are made available.

## Contributing

This project welcomes contributions and suggestions.
If you are ready to contribute, please visit the [contribution guide](CONTRIBUTING.md).

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Maintainers

- [Bernie White](https://github.com/BernieWhite)
- [Vic Perdana](https://github.com/vicperdana)

## License

This project is [licensed under the MIT License](LICENSE).

[issue]: https://github.com/Azure/PSDocs.Azure/issues
[discussion]: https://github.com/Azure/PSDocs.Azure/discussions
[install]: docs/install-instructions.md
[ci-badge]: https://dev.azure.com/PSDocs/PSDocs.Azure/_apis/build/status/PSDocs.Azure-CI?branchName=main
[module]: https://www.powershellgallery.com/packages/PSDocs.Azure
[engine]: https://github.com/BernieWhite/PSDocs
[create-workflow]: https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file
[source-template]: templates/storage/v1/template.json
[output-template]: templates/storage/v1/README.md
