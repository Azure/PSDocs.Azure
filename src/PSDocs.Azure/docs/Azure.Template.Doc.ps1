# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# Azure Resource Manager documentation definitions
#

# A function to break out parameters from an ARM template.
function global:GetTemplateParameter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    process {
        $template = Get-Content -Path $Path -Raw | ConvertFrom-Json;
        foreach ($property in $template.parameters.PSObject.Properties) {
            $result = [PSCustomObject]@{
                Name = $property.Name
                Description = ''
                DefaultValue = $Null
                AllowedValues = $Null
                Required = "Required"
            }
            if ([bool]$property.Value.PSObject.Properties['metadata'] -and [bool]$property.Value.metadata.PSObject.Properties['description']) {
                $result.Description = $property.Value.metadata.description;
            }
            if ([bool]$property.Value.PSObject.Properties['defaultValue']) {
                $result.DefaultValue = $property.Value.defaultValue;
                $result.Required = "Optional"
            }
            if ([bool]$property.Value.PSObject.Properties['allowedValues']) {
                $result.AllowedValues = $property.Value.allowedValues;
                $result.Required = "Optional"
            }
            $result;
        }
    }
}

# A function to create an example JSON parameter file snippet.
function global:GetTemplateExample {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    process {
        if (![System.IO.Path]::IsPathRooted($Path)) {
            $Path = Join-Path -Path $PWD -ChildPath $Path;
        }
        $template = Get-Content -Path $Path -Raw | ConvertFrom-Json;
        $normalPath = GetTemplateRelativePath -Path $Path;
        $baseContent = [PSCustomObject]@{
            '$schema'= "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json`#"
            contentVersion = '1.0.0.0'
            metadata = [PSCustomObject]@{
                template = $normalPath
            }
            parameters = [ordered]@{}
        }
        foreach ($property in $template.parameters.PSObject.Properties) {
            $propertyValue = $Null;
            $hasMetadata = [bool]$property.Value.PSObject.Properties['metadata'];

            if ($hasMetadata -and [bool]$property.Value.metadata.PSObject.Properties['ignore'] -and $True -eq $property.Value.metadata.ignore) {
                continue;
            }

            if ($property.Value.type -eq 'secureString') {
                $param = [PSCustomObject]@{
                    reference = [PSCustomObject]@{
                        keyVault = [PSCustomObject]@{
                            id = ''
                        }
                        secretName = ''
                    }
                };
                $baseContent.parameters[$property.Name] = $param;
                continue;
            }

            if ($hasMetadata -and [bool]$property.Value.metadata.PSObject.Properties['example'] -and $Null -ne $property.Value.metadata.example) {
                $propertyValue = $property.Value.metadata.example;
            }
            elseif ([bool]$property.Value.PSObject.Properties['defaultValue'] -and $Null -ne $property.Value.defaultValue) {
                $propertyValue = $property.Value.defaultValue;
            }
            elseif ($property.Value.type -eq 'array') {
                $propertyValue = @();
            }
            elseif ($property.Value.type -eq 'object') {
                $propertyValue = [PSCustomObject]@{};
            }
            elseif ($property.Value.type -eq 'int') {
                $propertyValue = 0;
            }
            elseif ($property.Value.type -eq 'string') {
                $propertyValue = '';
            }

            $param = [PSCustomObject]@{
                value = $propertyValue
            }
            $baseContent.parameters[$property.Name] = $param
        }
        $baseContent;
    }
}

# Synopsis: Function to get the relative path of the template
function global:GetTemplateRelativePath {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    process {
        if (![System.IO.Path]::IsPathRooted($Path)) {
            $Path = [System.IO.Path]::Combine($PWD, $Path);
        }
        $normalPath = [System.IO.Path]::GetFullPath($Path);
        if ($normalPath.StartsWith($PWD, [System.StringComparison]::InvariantCultureIgnoreCase)) {
            $normalPath = $normalPath.Substring(([String]$PWD).Length);
            $normalPath = $normalPath.Replace('\', '/').TrimStart('/')
        }
        return $normalPath;
    }
}

# A function to import metadata
function global:GetTemplateMetadata {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    process {
        $metadata = @{};

        # Get metadata from template file
        $template = Get-Content -Path $Path -Raw | ConvertFrom-Json;
        if ([bool]$template.PSObject.Properties['metadata']) {
            foreach ($property in $template.metadata.PSObject.Properties.GetEnumerator()) {
                $metadata[$property.Name] = $property.Value;
            }
        }

        # Get missing metadata from metadata.json
        $metadataFilePath = Join-Path -Path (Split-Path -Path $Path -Parent) -ChildPath 'metadata.json';
        if (Test-Path -Path $metadataFilePath) {
            $extraMetadata = Get-Content -Path $metadataFilePath -Raw | ConvertFrom-Json;
            foreach ($property in $extraMetadata.PSObject.Properties.GetEnumerator()) {

                if ($property.Name -eq 'itemDisplayName' -and !$metadata.ContainsKey('name')) {
                    $metadata['name'] = $property.Value;
                }
                elseif ($property.Name -eq 'summary' -and !$metadata.ContainsKey('summary')) {
                    $metadata['summary'] = $property.Value;
                }
                elseif ($property.Name -eq 'description' -and !$metadata.ContainsKey('description')) {
                    $metadata['description'] = $property.Value;
                }
                elseif (!$metadata.ContainsKey($property.Name) -and $property.Name -ne '$schema') {
                    $metadata[$property.Name] = $property.Value;
                }
            }
        }
        return $metadata;
    }
}

# A function to import outputs
function global:GetTemplateOutput {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    process {
        $template = Get-Content -Path $Path -Raw | ConvertFrom-Json;
        foreach ($property in $template.outputs.PSObject.Properties) {
            $output = [PSCustomObject]@{
                Name = $property.Name
                Type = $property.Value.type
                Description = ''
            }
            if ([bool]$property.Value.PSObject.Properties['metadata'] -and [bool]$property.Value.metadata.PSObject.Properties['description']) {
                $output.Description = $property.Value.metadata.description
            }
            $output;
        }
    }
}

# Synopsis: A definition to generate markdown for an ARM template
Document 'README' {

    # Read JSON files
    $templatePath = $InputObject;
    $parameters = GetTemplateParameter -Path $templatePath;
    $metadata = GetTemplateMetadata -Path $templatePath;
    $outputs = GetTemplateOutput -Path $templatePath;

    # Set document title
    if ($Null -ne $metadata -and $metadata.ContainsKey('name')) {
        Title $metadata.name
    }
    else {
        Title $LocalizedData.DefaultTitle
    }

    # Add short description
    if ($Null -ne $metadata -and $metadata.ContainsKey('summary')) {
        $metadata.summary
    }

    # Add badges
    $relativePath = (Split-Path (GetTemplateRelativePath -Path $templatePath) -Parent).Replace('\', '/').TrimStart('/');
    $relativePathEncoded = [System.Web.HttpUtility]::UrlEncode($relativePath);
    Include '.ps-docs/azure-template-badges.md' -ErrorAction SilentlyContinue -BaseDirectory $PWD -Replace @{
        '{{ template_path }}' = $relativePath
        '{{ template_path_encoded }}' = $relativePathEncoded
    }

    Write-Verbose $relativePath
    Write-Verbose $relativePathEncoded

    # Add detailed description
    if ($Null -ne $metadata -and $metadata.ContainsKey('description')) {
        $metadata.description
    }

    # Add table and detail for each parameter
    Section $LocalizedData.Parameters {
        $parameters | Table -Property @{ Name = $LocalizedData.ParameterName; Expression = { $_.Name }}, 
        @{ Name = $LocalizedData.Required; Expression = { $_.Required }}, 
        @{ Name = $LocalizedData.Description; Expression = { $_.Description }}

        foreach ($parameter in $parameters) {
            Section $parameter.Name {
                $parameter.Required;                
                $parameter.Description;

                if (![String]::IsNullOrEmpty($parameter.DefaultValue)) {
                    $LocalizedData.DefaultValue -f [String]::Concat('`', $parameter.DefaultValue, '`');
                }
                if ($Null -ne $parameter.AllowedValues -and $parameter.AllowedValues.Length -gt 0) {
                    $allowedValuesString = $parameter.AllowedValues | ForEach-Object {
                        [String]::Concat('`', $_, '`')
                    }
                    $LocalizedData.AllowedValues -f ([String]::Join(', ', $allowedValuesString));
                }
            }
        }
    }

    # Add table for outputs
    Section $LocalizedData.Outputs {
        $outputs | Table -Property @{ Name = $LocalizedData.Name; Expression = { $_.Name }},
            @{ Name = $LocalizedData.Type; Expression = { $_.Type }},
            @{ Name = $LocalizedData.Description; Expression = { $_.Description }}
    }

    # Insert snippets
    Section $LocalizedData.Snippets {

        # Add parameter file snippet
        if ($PSDocs.Configuration.GetBoolOrDefault('AZURE_USE_PARAMETER_FILE_SNIPPET', $True)) {
            Section $LocalizedData.ParameterFile {
                $example = GetTemplateExample -Path $templatePath;
                $example | Code 'json'
            }
        }
        # Add command line snippet
        if ($PSDocs.Configuration.GetBoolOrDefault('AZURE_USE_COMMAND_LINE_SNIPPET', $False)) {
            Section $LocalizedData.CommandLine {
                Section 'PowerShell' {
                    'New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group-name> -TemplateFile <path-to-template> -TemplateParameterFile <path-to-templateparameter>' | Code powershell
                }
                Section 'Azure CLI' {
                    'az group deployment create --name <deployment-name> --resource-group <resource-group-name> --template-file <path-to-template> --parameters @<path-to-templateparameterfile>' | Code text
                }
            }
        }
    }
}
