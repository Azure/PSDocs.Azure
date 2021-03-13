# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# Unit tests for PSDocs.Azure document conventions
#

[CmdletBinding()]
param ()

# Setup error handling
$ErrorActionPreference = 'Stop';
Set-StrictMode -Version latest;

# Setup tests paths
$rootPath = $PWD;
$here = $PSScriptRoot;

Import-Module (Join-Path -Path $rootPath -ChildPath out/modules/PSDocs.Azure) -Force;

$outputPath = Join-Path -Path $rootPath -ChildPath out/tests/PSDocs.Azure.Tests/Conventions;
Remove-Item -Path $outputPath -Force -Recurse -Confirm:$False -ErrorAction Ignore;
$Null = New-Item -Path $outputPath -ItemType Directory -Force;

Describe 'Conventions' -Tag 'Conventions' {
    Context 'Azure.NameByParentPath' {
        It 'Uses naming convention' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
            }

            # Generates templates
            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/';
            $result = Get-AzDocTemplateFile -Path $templatePath | ForEach-Object {
                $template = Get-Item -Path $_.TemplateFile;
                Invoke-PSDocument @invokeParams -OutputPath $outputPath -InputObject $template.FullName -Convention 'Azure.NameByParentPath'
            }
            $result | Should -Not -BeNullOrEmpty;
            $result[0].Name | Should -BeLike 'storage_v1.md';
            $result;

            # Generates templates without version path
            $templatePath = Join-Path -Path $here -ChildPath 'template-test/';
            $result = Get-AzDocTemplateFile -Path $templatePath | ForEach-Object {
                $template = Get-Item -Path $_.TemplateFile;
                Invoke-PSDocument @invokeParams -OutputPath $outputPath -InputObject $template.FullName -Convention 'Azure.NameByParentPath'
            }
            $result | Should -Not -BeNullOrEmpty;
            $result[0].Name | Should -BeLike 'template-test.md';
            $result;
        }
    }
}
