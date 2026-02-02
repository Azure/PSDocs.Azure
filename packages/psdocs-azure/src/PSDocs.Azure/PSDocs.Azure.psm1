# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#
# PSDocs.Azure module
#

Set-StrictMode -Version latest;

[PSDocs.Azure.Configuration.PSDocumentOption]::UseExecutionContext($ExecutionContext);

#
# Localization
#

#
# Public functions
#

#region Public functions

# .ExternalHelp PSDocs.Azure-Help.xml
function Get-AzDocTemplateFile {
    [CmdletBinding()]
    [OutputType([PSDocs.Azure.Data.Metadata.ITemplateLink])]
    param (
        [Parameter(Position = 1, Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [Alias('f', 'TemplateFile', 'FullName')]
        [SupportsWildcards()]
        [String[]]$InputPath = '*.json',

        [Parameter(Position = 0, Mandatory = $False)]
        [Alias('p')]
        [String]$Path = $PWD
    )
    begin {
        Write-Verbose -Message "[Get-AzDocTemplateFile] BEGIN::";

        # Build the pipeline
        $builder = [PSDocs.Azure.Pipeline.PipelineBuilder]::Template($Path);
        $builder.UseCommandRuntime($PSCmdlet);
        $builder.UseExecutionContext($ExecutionContext);
        $pipeline = $builder.Build();
        if ($Null -ne (Get-Variable -Name pipeline -ErrorAction SilentlyContinue)) {
            try {
                $pipeline.Begin();
            }
            catch {
                $pipeline.Dispose();
                throw;
            }
        }
    }
    process {
        if ($Null -ne (Get-Variable -Name pipeline -ErrorAction SilentlyContinue)) {
            try {
                foreach ($p in $InputPath) {
                    $pipeline.Process($p);
                }
            }
            catch {
                $pipeline.Dispose();
                throw;
            }
        }
    }
    end {
        if ($Null -ne (Get-Variable -Name pipeline -ErrorAction SilentlyContinue)) {
            try {
                $pipeline.End();
            }
            finally {
                $pipeline.Dispose();
            }
        }
        Write-Verbose -Message "[Get-AzDocTemplateFile] END::";
    }
}

#endregion Public functions

#
# Export module
#

Export-ModuleMember -Function @(
    'Get-AzDocTemplateFile'
);

# EOM
