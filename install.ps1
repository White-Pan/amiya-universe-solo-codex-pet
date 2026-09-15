[CmdletBinding()]
param(
    [string]$CodexHome = $env:CODEX_HOME,
    [switch]$Update
)
$ErrorActionPreference = 'Stop'
$petId = 'amiya-universe-solo'
if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    $CodexHome = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex'
}
$petSource = Join-Path $PSScriptRoot 'pet'
$files = @('pet.json', 'spritesheet.webp')
$manifest = Get-Content -LiteralPath (Join-Path $petSource 'pet.json') -Raw -Encoding UTF8 | ConvertFrom-Json
if ($manifest.id -ne $petId -or $manifest.spriteVersionNumber -ne 2 -or $manifest.spritesheetPath -ne 'spritesheet.webp') {
    throw 'Unexpected pet manifest. Download a complete, unmodified package.'
}
$hashes = @{}
foreach ($line in Get-Content -LiteralPath (Join-Path $PSScriptRoot 'checksums.sha256')) {
    if ($line -match '^([0-9a-fA-F]{64})\s+pet/(.+)$') { $hashes[$Matches[2]] = $Matches[1] }
}
foreach ($name in $files) {
    $sourceFile = Join-Path $petSource $name
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) { throw "Missing file: $name" }
    if (-not $hashes.ContainsKey($name) -or (Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash -ne $hashes[$name]) {
        throw "Checksum mismatch: $name. Download the package again."
    }
}
$petsRoot = [IO.Path]::GetFullPath((Join-Path $CodexHome 'pets'))
$destination = [IO.Path]::GetFullPath((Join-Path $petsRoot $petId))
if ([IO.Path]::GetDirectoryName($destination) -ne $petsRoot) { throw 'Invalid installation path.' }
foreach ($candidate in @($petsRoot, $destination)) {
    if ((Test-Path -LiteralPath $candidate) -and ((Get-Item -LiteralPath $candidate).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw "Refusing to install through a linked directory: $candidate"
    }
}
$different = $false
foreach ($name in $files) {
    $existing = Join-Path $destination $name
    if (Test-Path -LiteralPath $existing) {
        if (-not (Test-Path -LiteralPath $existing -PathType Leaf)) { throw "Expected a file: $existing" }
        if ((Get-Item -LiteralPath $existing).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Refusing linked file: $existing" }
        if ((Get-FileHash -LiteralPath $existing).Hash -ne $hashes[$name]) { $different = $true }
    }
}
if ($different -and -not $Update) { throw 'A different version is installed. To back it up and update, run: powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Update' }
New-Item -ItemType Directory -Force -Path $destination | Out-Null
if ($different) {
    $backup = Join-Path $destination ('backups/' + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-fffffff'))
    New-Item -ItemType Directory -Path $backup | Out-Null
    foreach ($name in $files) {
        $existing = Join-Path $destination $name
        if (Test-Path -LiteralPath $existing -PathType Leaf) { Copy-Item -LiteralPath $existing -Destination (Join-Path $backup $name) }
    }
    Write-Host "Previous files backed up to: $backup"
}
foreach ($name in $files) { Copy-Item -LiteralPath (Join-Path $petSource $name) -Destination (Join-Path $destination $name) }
Write-Host "Installed Amiya to: $destination"
Write-Host 'Restart Codex if needed, then select Amiya in the pet picker.'
