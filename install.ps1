[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path $PSScriptRoot).Path
$config = Join-Path $repoRoot '.tmux.conf'
$configDir = Join-Path $HOME '.config/tmux'
$target = Join-Path $configDir 'tmux.conf'

if (-not (Test-Path -LiteralPath $config -PathType Leaf)) {
    throw "Expected configuration file was not found: $config"
}

if (-not (Get-Command tmux -ErrorAction SilentlyContinue)) {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install tmux
    }
    elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install tmux -y
    }
    else {
        throw 'tmux is required. Install Scoop or Chocolatey, install tmux, then rerun this script.'
    }
}

New-Item -ItemType Directory -Force -Path $configDir | Out-Null

if (Test-Path -LiteralPath $target) {
    $item = Get-Item -LiteralPath $target -Force
    if ($item.LinkType -and $item.Target -eq $config) {
        Write-Output "$target is already linked to this repository."
        exit 0
    }

    $backup = "$target.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Move-Item -LiteralPath $target -Destination $backup
    Write-Output "Backed up $target to $backup"
}

New-Item -ItemType SymbolicLink -Path $target -Target $config | Out-Null
Write-Output "Linked $target to $config"
