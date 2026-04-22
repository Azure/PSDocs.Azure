# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Common build utilities for all packages in the monorepo
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Component
)

function Get-MonorepoRoot {
    $current = $PSScriptRoot
    while ($current -ne [System.IO.Path]::GetPathRoot($current)) {
        if (Test-Path (Join-Path $current 'packages')) {
            return $current
        }
        $current = Split-Path $current -Parent
    }
    throw "Could not find monorepo root"
}

function Install-BuildDependencies {
    [CmdletBinding()]
    param()
    
    Write-Host "Checking build dependencies..." -ForegroundColor Cyan
    
    # Try to install NuGet provider
    try {
        if ($Null -eq (Get-PackageProvider -Name NuGet -ErrorAction Ignore)) {
            Write-Host "  Installing NuGet package provider..."
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction Stop | Out-Null
        }
    } catch {
        Write-Host "  Note: NuGet provider installation skipped (not available in this environment)" -ForegroundColor Yellow
    }
    
    # Try to install/update PowerShellGet
    try {
        if ($Null -eq (Get-InstalledModule -Name PowerShellGet -MinimumVersion 2.2.1 -ErrorAction Ignore -WarningAction SilentlyContinue)) {
            Write-Host "  Installing PowerShellGet module..."
            Install-Module PowerShellGet -MinimumVersion 2.2.1 -Scope CurrentUser -Force -AllowClobber -WarningAction SilentlyContinue -ErrorAction Stop | Out-Null
        }
    } catch {
        Write-Host "  Note: PowerShellGet installation skipped (not available in this environment)" -ForegroundColor Yellow
    }
    
    # Try to install InvokeBuild
    try {
        if ($Null -eq (Get-InstalledModule -Name InvokeBuild -MinimumVersion 5.4.0 -ErrorAction Ignore)) {
            Write-Host "  Installing InvokeBuild module..."
            Install-Module InvokeBuild -MinimumVersion 5.4.0 -Scope CurrentUser -Force -ErrorAction Stop | Out-Null
        }
    } catch {
        Write-Host "  Note: InvokeBuild installation skipped (not available in this environment)" -ForegroundColor Yellow
    }
    
    # Try to install Pester
    try {
        if ($Null -eq (Get-InstalledModule -Name Pester -MinimumVersion 5.0.0 -ErrorAction Ignore)) {
            Write-Host "  Installing Pester module..."
            Install-Module Pester -MinimumVersion 5.0.0 -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop | Out-Null
        }
    } catch {
        Write-Host "  Note: Pester installation skipped (not available in this environment)" -ForegroundColor Yellow
    }
    
    Write-Host "  Dependencies check complete!" -ForegroundColor Green
}

function Get-LocalPSDocsModule {
    [CmdletBinding()]
    param()
    
    $root = Get-MonorepoRoot
    $localModule = Join-Path $root 'packages/psdocs/out/modules/PSDocs'
    
    if (Test-Path $localModule) {
        Write-Host "Using local PSDocs module from: $localModule"
        $env:PSModulePath = "$localModule$([IO.Path]::PathSeparator)$env:PSModulePath"
        return $true
    }
    
    Write-Host "Local PSDocs module not found, will use PSGallery version"
    return $false
}
