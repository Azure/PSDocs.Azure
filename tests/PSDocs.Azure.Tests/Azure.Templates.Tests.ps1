# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# Unit tests for PSDocs.Azure functionality using example templates
#

[CmdletBinding()]
param ()

# Setup error handling
$ErrorActionPreference = 'Stop';
Set-StrictMode -Version latest;

# Setup tests paths
$rootPath = $PWD;

Import-Module (Join-Path -Path $rootPath -ChildPath out/modules/PSDocs.Azure) -Force;

$outputPath = Join-Path -Path $rootPath -ChildPath out/tests/PSDocs.Azure.Tests/Common;
Remove-Item -Path $outputPath -Force -Recurse -Confirm:$False -ErrorAction Ignore;
$Null = New-Item -Path $outputPath -ItemType Directory -Force;

Describe 'Templates' -Tag 'Template' {
    $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/';

    Context 'Documentation for examples' {
        It 'Generates expected output' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                # Option = (New-PSDocumentOption -Option @{ 'CONFIGURATION.AZURE_BICEP_REGISTRY_MODULES_METADATA_SCHEMA_ENABLED' = $False })
            }

            # Generates templates
            $result = Get-AzDocTemplateFile -Path $templatePath | ForEach-Object {
                $template = Get-Item -Path $_.TemplateFile;
                $parentPath = $template.Directory.FullName;
                $expectedContent = Get-Content -Path (Join-Path -Path $parentPath -ChildPath 'README.md') -Raw;
                $actualContent = Invoke-PSDocument @invokeParams -Option (New-PSDocumentOption -Option @{ 'CONFIGURATION.AZURE_BICEP_REGISTRY_MODULES_METADATA_SCHEMA_ENABLED' = $False }) -OutputPath $outputPath -InputPath $template.FullName -PassThru;
                $actualContent | Should -BeExactly $expectedContent;
                $actualContent;
            }
            $result | Should -Not -BeNullOrEmpty;
        }
    }
}
