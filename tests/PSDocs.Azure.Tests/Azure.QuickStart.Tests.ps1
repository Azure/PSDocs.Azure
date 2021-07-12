# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# Unit tests for PSDocs.Azure functionality Azure Quick Start templates
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
$here = $PSScriptRoot;

Describe 'Templates' -Tag 'QuickStart' {
    Context 'Documentation for examples' {
        It 'Generates expected output' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = (New-PSDocumentOption)
            }

            Push-Location -Path $here;
            $templatePath = Join-Path -Path $here -ChildPath 'template-test/';
            try {
                # Generates templates
                $result = Get-AzDocTemplateFile -Path $templatePath | ForEach-Object {
                    $template = Get-Item -Path $_.TemplateFile;
                    $actualContent = Invoke-PSDocument @invokeParams -OutputPath $outputPath -InputPath $template.FullName -PassThru;
                    $actualContent | Should -BeLike '*!`[Azure Public Test Date`](https://azurequickstartsservice.blob.core.windows.net/badges/template-test/PublicLastTestDate.svg)*';
                    $actualContent | Should -BeLike "`# Storage Account*";
                    $actualContent | Should -BeLike "*Create an empty Storage Account.*";
                    $actualContent | Should -BeLike "*This template deploys a Storage Account including blob containers and files shares. Encryption in transit it enabled using a minimum of TLS 1.2.*";
                    $actualContent;
                }
                $result | Should -Not -BeNullOrEmpty;
            }
            finally {
                Pop-Location;
            }
        }
    }
}
