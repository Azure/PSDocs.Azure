#Requires -Version 7.0

<#
.SYNOPSIS
    Extract a per-version section from a CHANGELOG.md file.

.DESCRIPTION
    Locates a heading of the form `## v{Version}` (optionally followed by
    additional text in parentheses or whitespace) and emits every line up to
    but not including the next `## ` heading. The heading line itself is
    excluded from the output. Used by the release-* GitHub Actions workflows
    to produce the --notes-file content for `gh release create` and the
    ReleaseNotes value passed to PSGallery.

.PARAMETER ChangelogPath
    Path to the CHANGELOG.md file to read.

.PARAMETER Version
    The version string to look up, without the leading 'v'. Examples:
    '0.10.0', '0.5.0-preview.1', '0.4.0-B2107030'.

.PARAMETER OutputPath
    Optional. When provided, writes the extracted notes to this file in
    addition to STDOUT.

.PARAMETER AllowEmpty
    When set, an empty body for the matched section emits a warning instead
    of failing.

.EXAMPLE
    pwsh ./scripts/extract-release-notes.ps1 -ChangelogPath ./CHANGELOG.md -Version 0.5.0

.EXAMPLE
    pwsh ./scripts/extract-release-notes.ps1 `
        -ChangelogPath ./packages/vscode-extension/CHANGELOG.md `
        -Version 0.4.0 -OutputPath ./release-notes.md

.NOTES
    Exits with a non-zero exit code on any of: file not found, version not
    found, or empty body without -AllowEmpty.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $ChangelogPath,

    [Parameter(Mandatory)]
    [string] $Version,

    [Parameter()]
    [string] $OutputPath,

    [Parameter()]
    [switch] $AllowEmpty
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ChangelogPath -PathType Leaf)) {
    Write-Error "CHANGELOG file not found: $ChangelogPath"
    exit 2
}

$lines = Get-Content -LiteralPath $ChangelogPath

# Match `## v{Version}` exactly, where the version may be followed by
# end-of-line, whitespace, or '(' (e.g. `## v0.3.3 (27 May 2024)`).
$escaped = [regex]::Escape($Version)
$headingPattern = "^##\s+v$escaped(\s|\(|$)"
$nextHeadingPattern = '^##\s+'

$startIndex = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match $headingPattern) {
        $startIndex = $i
        break
    }
}

if ($startIndex -lt 0) {
    Write-Error "Version 'v$Version' not found in $ChangelogPath. Looked for heading matching: $headingPattern"
    exit 3
}

$endIndex = $lines.Count
for ($i = $startIndex + 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match $nextHeadingPattern) {
        $endIndex = $i
        break
    }
}

# Body is everything between (exclusive) the matched heading and the next
# `## ` heading (or EOF). Trim leading/trailing blank lines.
$body = if (($endIndex - $startIndex - 1) -gt 0) {
    $lines[($startIndex + 1)..($endIndex - 1)]
} else {
    @()
}

# Trim leading blanks
while ($body.Count -gt 0 -and [string]::IsNullOrWhiteSpace($body[0])) {
    $body = $body[1..($body.Count - 1)]
}
# Trim trailing blanks
while ($body.Count -gt 0 -and [string]::IsNullOrWhiteSpace($body[-1])) {
    $body = $body[0..($body.Count - 2)]
}

if ($body.Count -eq 0) {
    if ($AllowEmpty) {
        Write-Warning "Section 'v$Version' is empty in $ChangelogPath"
    } else {
        Write-Error "Section 'v$Version' is empty in $ChangelogPath. Pass -AllowEmpty to permit."
        exit 4
    }
}

$output = ($body -join [Environment]::NewLine)

if ($OutputPath) {
    $output | Set-Content -LiteralPath $OutputPath -NoNewline -Encoding utf8
}

Write-Output $output
