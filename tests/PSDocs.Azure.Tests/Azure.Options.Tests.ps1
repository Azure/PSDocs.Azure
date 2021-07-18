# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# Unit tests for PSDocs.Azure options
#

[CmdletBinding()]
param ()

# Setup error handling
$ErrorActionPreference = 'Stop';
Set-StrictMode -Version latest;

# Setup tests paths
$rootPath = $PWD;
Import-Module (Join-Path -Path $rootPath -ChildPath out/modules/PSDocs.Azure) -Force;

Describe 'Options' -Tag 'Options' {
    Context 'AZURE_USE_PARAMETER_FILE_SNIPPET' {
        It 'With default' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -BeLike "*`"contentVersion`": `"1.0.0.0`"*";
        }

        It 'With true' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_USE_PARAMETER_FILE_SNIPPET' = $True
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -BeLike "*`"contentVersion`": `"1.0.0.0`"*";
        }

        It 'With false' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_USE_PARAMETER_FILE_SNIPPET' = $False
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -Not -BeLike "*`"contentVersion`": `"1.0.0.0`"*";
        }
    }

    Context 'AZURE_USE_COMMAND_LINE_SNIPPET' {
        It 'With default' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -Not -BeLike "*az group deployment create*";
        }

        It 'With true' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_USE_COMMAND_LINE_SNIPPET' = $True
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -BeLike "*az group deployment create*";
        }

        It 'With false' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_USE_COMMAND_LINE_SNIPPET' = $False
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -Not -BeLike "*az group deployment create*";
        }
    }

    Context 'AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER' {
        It 'With default' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -BeLike "*`"sku`": {*";
        }

        It 'With true' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER' = $True
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -Not -BeLike "*`"sku`": {*";
        }

        It 'With false' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER' = $False
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -BeLike "*`"sku`": {*";
        }
    }

    Context 'AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN' {
        It 'With default' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -Not -BeLike "*`"location`": {*";
        }

        It 'With true' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN' = $True
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -Not -BeLike "*`"location`": {*";
        }

        It 'With false' {
            $invokeParams = @{
                Module = 'PSDocs.Azure'
                Option = @{
                    'Configuration.AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN' = $False
                }
            }

            $templatePath = Join-Path -Path $rootPath -ChildPath 'templates/storage/v1/';
            $result = Invoke-PSDocument @invokeParams -InputPath $templatePath -PassThru | Out-String;
            $result | Should -Not -BeNullOrEmpty;
            $result | Should -BeLike "*`"location`": {*";
        }
    }
}
