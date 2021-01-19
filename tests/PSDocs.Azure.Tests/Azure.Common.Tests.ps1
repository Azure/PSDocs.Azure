# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# Unit tests for core PSDocs.Azure functionality
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

Describe 'PSDocs' -Tag 'PSDocs', 'Common' {
    Context 'Get-PSDocument' {
        It 'Returns documents' {
            $result = @(Get-PSDocument -Module 'PSDocs.Azure');
            $result | Should -Not -BeNullOrEmpty;
            $result.Length | Should -Be 1;
            $result.Id | Should -BeIn 'PSDocs.Azure\README';
        }
    }

    Context 'Invoke-PSDocument' {
        It 'Generates documents' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                OutputPath = $outputPath
                InputObject = (Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/template.json')
            }
            $result = Invoke-PSDocument @invokeParams;
            $result | Should -Not -BeNullOrEmpty;
        }

        It 'With basic template' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                OutputPath = $outputPath
                InputObject = (Join-Path -Path $rootPath -ChildPath 'tests/PSDocs.Azure.Tests/basic.template.json')
            }
            $result = Invoke-PSDocument @invokeParams;
            $result | Should -Not -BeNullOrEmpty;
        }

        It 'With relative path' {
            Push-Location -Path (Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/');
            try {
                $invokeParams = @{
                    Module = 'PSDocs.Azure'
                    OutputPath = $outputPath
                    InputObject = './template.json'
                    Option = @{ 'Output.Culture' = 'en-US' }
                }
                $result = Invoke-PSDocument @invokeParams;
                $result | Should -Not -BeNullOrEmpty;
            }
            finally {
                Pop-Location;
            }
        }
    }
}

Describe 'Get-AzDocTemplateFile' -Tag 'Cmdlet', 'Common', 'Get-AzDocTemplateFile' {
    $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/';

    Context 'With -Path' {
        It 'Get template files' {
            $result = @(Get-AzDocTemplateFile -Path $templatePath);
            $result | Should -Not -BeNullOrEmpty;
            $result.Length | Should -Be 1;
            $result.Name | Should -BeIn 'Storage Account';
            $result.Version.ToString() | Should -Be '1.0.0.0';
        }
    }
}
