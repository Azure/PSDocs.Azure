# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Invoke-Build
# CI pipeline script for PSDocs-vscode

[CmdletBinding()]
param (
    [Parameter(Mandatory = $False)]
    [String]$Build = '0.0.1',

    [Parameter(Mandatory = $False)]
    [ValidateSet('preview', 'stable', 'dev')]
    [String]$Channel,

    [Parameter(Mandatory = $False)]
    [String]$Configuration = 'Debug',

    [Parameter(Mandatory = $False)]
    [String]$OutputPath = (Join-Path -Path $PWD -ChildPath out),

    [Parameter(Mandatory = $False)]
    [String]$ApiKey,

    [Parameter(Mandatory = $False)]
    [String]$AssertStyle = 'AzurePipelines'
)

$commitId = git log --format="%H" -n 1;

Write-Host -Object "[Pipeline] -- PWD: $PWD" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- OutputPath: $OutputPath" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- BuildNumber: $($Env:BUILD_BUILDNUMBER)" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- CommitId: $($commitId)" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- SourceBranch: $($Env:BUILD_SOURCEBRANCH)" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- SourceBranchName: $($Env:BUILD_SOURCEBRANCHNAME)" -ForegroundColor Green;

if ($Env:SYSTEM_DEBUG -eq 'true') {
    $VerbosePreference = 'Continue';
}

if ($Env:BUILD_SOURCEBRANCH -like '*/tags/*' -and $Env:BUILD_SOURCEBRANCHNAME -like 'v1.*') {
    $Build = $Env:BUILD_SOURCEBRANCHNAME.Substring(1);
}

$version = $Build;

# Handle channel
if ([String]::IsNullOrEmpty('Channel')) {
    $Channel = 'preview';
}
$channelSuffix = '-preview';
$channelDisplayName = 'PSDocs.Azure (Preview)';
switch ($Channel) {
    'dev' { $channelSuffix = '-dev'; $channelDisplayName = 'PSDocs.Azure (Dev)'; }
    'stable' { $channelSuffix = ''; $channelDisplayName = 'PSDocs.Azure'; }
    default { $channelSuffix = '-preview'; $channelDisplayName = 'PSDocs.Azure (Preview)'; }
}

Write-Host -Object "[Pipeline] -- Using channel: $Channel" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- Using channelSuffix: $channelSuffix" -ForegroundColor Green;
Write-Host -Object "[Pipeline] -- Using version: $version" -ForegroundColor Green;

$packageRoot = Join-Path -Path $OutputPath -ChildPath 'package';
$packageName = "PSDocs-vscode$channelSuffix";
$packagePath = Join-Path -Path $packageRoot -ChildPath "$packageName.vsix";

function Get-RepoRuleData {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $False)]
        [String]$Path = $PWD
    )
    process {
        GetPathInfo -Path $Path -Verbose:$VerbosePreference;
    }
}

function GetPathInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    begin {
        $items = New-Object -TypeName System.Collections.ArrayList;
    }
    process {
        $Null = $items.Add((Get-Item -Path $Path));
        $files = @(Get-ChildItem -Path $Path -File -Recurse -Include *.ps1,*.psm1,*.psd1,*.cs | Where-Object {
            !($_.FullName -like "*.Designer.cs") -and
            !($_.FullName -like "*/bin/*") -and
            !($_.FullName -like "*/obj/*") -and
            !($_.FullName -like "*\obj\*") -and
            !($_.FullName -like "*\bin\*") -and
            !($_.FullName -like "*\out\*") -and
            !($_.FullName -like "*/out/*")
        });
        $Null = $items.AddRange($files);
    }
    end {
        $items;
    }
}

task BuildExtension {
    Write-Host '> Building extension' -ForegroundColor Green;
    exec { & npm run compile }
}

task PackageExtension {
    Write-Host '> Packaging PSDocs-vscode' -ForegroundColor Green;
    if (!(Test-Path -Path $packageRoot)) {
        $Null = New-Item -Path $packageRoot -ItemType Directory -Force;
    }
    exec { & npm run pack -- --out $packagePath }
}

# Synopsis: Install the extension in Visual Studio Code
task InstallExtension {
    Write-Host '> Installing PSDocs-vscode' -ForegroundColor Green;
    exec { & code --install-extension $packagePath --force }
}

task VersionExtension {
    # Update channel name
    $package = Get-Content ./package.json -Raw | ConvertFrom-Json;
    if ($package.name -ne $packageName) {
        $package.name = $packageName;
        $package | ConvertTo-Json -Depth 99 | Set-Content ./package.json;
    }

    # Update channel flag
    $package = Get-Content ./package.json -Raw | ConvertFrom-Json;
    $previewFlag = $Channel -ne 'stable';
    if ($package.preview -ne $previewFlag) {
        $package.preview = $previewFlag;
        $package | ConvertTo-Json -Depth 99 | Set-Content ./package.json;
    }

    # Update channel display name
    $package = Get-Content ./package.json -Raw | ConvertFrom-Json;
    if ($package.displayName -ne $channelDisplayName) {
        $package.displayName = $channelDisplayName;
        $package | ConvertTo-Json -Depth 99 | Set-Content ./package.json;
    }

    if (![String]::IsNullOrEmpty($Build)) {
        # Update extension version
        if (![String]::IsNullOrEmpty($version)) {
            Write-Verbose -Message "[VersionExtension] -- Updating extension version";
            $package = Get-Content ./package.json -Raw | ConvertFrom-Json;

            if ($package.version -ne $version) {
                $package.version = $version;
                $package | ConvertTo-Json -Depth 99 | Set-Content ./package.json;
            }
        }
    }
}

# Synopsis: Install NuGet provider
task NuGet {
    if ($Null -eq (Get-PackageProvider -Name NuGet -ErrorAction Ignore)) {
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser;
    }
}

# Synopsis: Install PSDocs
task PSDocs NuGet, {
    if ($Null -eq (Get-InstalledModule -Name PSDocs.Azure -MinimumVersion 0.3.0 -ErrorAction Ignore)) {
        Install-Module -Name PSDocs.Azure -Repository PSGallery -MinimumVersion 0.3.0 -Scope CurrentUser -Force;
    }
    Import-Module -Name PSDocs -Verbose:$False;
}

# Synopsis: Remove temp files
task Clean {
    Remove-Item -Path out,reports -Recurse -Force -ErrorAction Ignore;
}

# Synopsis: Restore NPM packages
task PackageRestore {
    exec { & npm install --no-save }
}

task ReleaseExtension {
    exec { & npm install vsce --no-save }
    exec { & npm run publish -- --packagePath $packagePath --pat $ApiKey }
}

# Synopsis: Add shipit build tag
task TagBuild {
    if ($Null -ne $Env:BUILD_DEFINITIONNAME) {
        Write-Host "`#`#vso[build.addbuildtag]shipit";
    }
}

task Build Clean, PackageRestore, VersionExtension, PackageExtension

task Install Build, InstallExtension

task . Build

task Release VersionExtension, ReleaseExtension, TagBuild
