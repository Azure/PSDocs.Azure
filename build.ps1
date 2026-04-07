#!/usr/bin/env pwsh
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Root build orchestrator for PSDocs monorepo

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('psdocs', 'psdocs-azure', 'vscode', 'all')]
    [string]$Package = 'all',
    
    [Parameter()]
    [switch]$Build,
    
    [Parameter()]
    [switch]$Test,
    
    [Parameter()]
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'

# Import common utilities
. $PSScriptRoot/build/common.ps1

function Invoke-PackageBuild {
    param(
        [string]$PackagePath,
        [string]$PackageName,
        [switch]$Build,
        [switch]$Test,
        [switch]$Clean
    )
    
    if (-not (Test-Path $PackagePath)) {
        Write-Host "Package '$PackageName' not found at $PackagePath - skipping" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Building: $PackageName" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Push-Location $PackagePath
    try {
        $buildScript = './pipeline.build.ps1'
        if (Test-Path $buildScript) {
            # pipeline.build.ps1 is an InvokeBuild script - use Invoke-Build
            $tasks = @()
            if ($Clean) { $tasks += 'Clean' }
            if ($Build) { $tasks += 'Build' }
            if ($Test) { $tasks += 'Test' }
            if ($tasks.Count -gt 0) {
                Invoke-Build -Task $tasks -File $buildScript
            }
        } elseif (Test-Path 'package.json') {
            # Node.js package (VS Code extension)
            if ($Clean) { 
                Remove-Item -Path 'node_modules', 'out', '*.vsix' -Recurse -Force -ErrorAction SilentlyContinue 
            }
            if ($Build) {
                npm ci
                npm run compile
            }
            if ($Test) {
                npm run lint
            }
        }
    }
    finally {
        Pop-Location
    }
}

# Install dependencies
Install-BuildDependencies

# Determine which packages to build
$packages = @()
switch ($Package) {
    'psdocs' { $packages = @('psdocs') }
    'psdocs-azure' { $packages = @('psdocs', 'psdocs-azure') }  # psdocs-azure depends on psdocs
    'vscode' { $packages = @('vscode') }
    'all' { $packages = @('psdocs', 'psdocs-azure', 'vscode') }
}

# Build packages in order
foreach ($pkg in $packages) {
    $pkgPath = switch ($pkg) {
        'psdocs' { "$PSScriptRoot/packages/psdocs" }
        'psdocs-azure' { "$PSScriptRoot/packages/psdocs-azure" }
        'vscode' { "$PSScriptRoot/packages/vscode-extension" }
    }
    
    Invoke-PackageBuild -PackagePath $pkgPath -PackageName $pkg -Build:$Build -Test:$Test -Clean:$Clean
    
    # After building psdocs, set up module path for psdocs-azure
    if ($pkg -eq 'psdocs' -and $Build) {
        $moduleInitialized = Get-LocalPSDocsModule
        if (-not $moduleInitialized) {
            Write-Error "Failed to locate or initialize the local PSDocs module. Cannot continue building dependent packages."
        }
    }
}

Write-Host "`n✅ Build complete!" -ForegroundColor Green
