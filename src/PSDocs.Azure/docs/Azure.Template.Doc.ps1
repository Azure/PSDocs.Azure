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
            [PSCustomObject]@{
                Name = $property.Name
                Description = $property.Value.metadata.description
                DefaultValue = $property.Value.defaultValue
                AllowedValues = $property.Value.allowedValues
            }
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
        $normalPath = $Path;
        if ($normalPath.StartsWith($PWD, [System.StringComparison]::InvariantCultureIgnoreCase)) {
            $normalPath = $Path.Substring(([String]$PWD).Length);
            $normalPath = ($normalPath -replace '\\', '/').TrimStart('/');
        }
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

            if ($True -eq $property.Value.metadata.ignore) {
                continue;
            }

            if ($property.Value.type -eq 'securestring') {
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

            if ($Null -ne $property.Value.metadata.example) {
                $propertyValue = $property.Value.metadata.example;
            }
            elseif ($Null -ne $property.Value.defaultValue) {
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

# A function to import metadata
function global:GetTemplateMetadata {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    process {
        return (Get-Content -Path $Path -Raw | ConvertFrom-Json).metadata;
    }
}

# Synopsis: A definition to generate markdown for an ARM template
Document 'README' {

    # Read JSON files
    $templatePath = $InputObject;
    $parameters = GetTemplateParameter -Path $templatePath;
    $metadata = GetTemplateMetadata -Path $templatePath;

    # Set document title
    Title $metadata.name

    # Write opening line
    $metadata.Description

    # Add each parameter to a table
    Section $LocalizedData.Parameters {
        $parameters | Table -Property @{ Name = $LocalizedData.ParameterName; Expression = { $_.Name }}, $LocalizedData.Description

        foreach ($parameter in $parameters) {
            Section $parameter.Name {
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

    $example = GetTemplateExample -Path $templatePath;
    Section $LocalizedData.Snippets {
        $example | Code 'json'
    }
}
