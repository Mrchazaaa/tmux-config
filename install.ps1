[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path $PSScriptRoot).Path
$configDir = Join-Path $HOME '.config/tmux'
$repoCopy = Join-Path $configDir 'tmux-config'
$target = Join-Path $configDir 'tmux.conf'
$legacy = Join-Path $HOME '.tmux.conf'

if (-not (Test-Path -LiteralPath (Join-Path $repoRoot '.tmux.conf') -PathType Leaf)) {
    throw "Expected configuration file was not found: $(Join-Path $repoRoot '.tmux.conf')"
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

function Backup-IfPresent($Path) {
    if (Test-Path -LiteralPath $Path) {
        $backup = "$Path.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Move-Item -LiteralPath $Path -Destination $backup
        Write-Output "Backed up $Path to $backup"
    }
}

Backup-IfPresent $repoCopy
Copy-Item -LiteralPath $repoRoot -Destination $repoCopy -Recurse -Force

function Write-Source($Path, $Source) {
    $line = "source-file $Source"
    if ((Test-Path -LiteralPath $Path -PathType Leaf) -and ((Get-Content -LiteralPath $Path -Raw).TrimEnd() -eq $line)) {
        return
    }
    Backup-IfPresent $Path
    Set-Content -LiteralPath $Path -Value $line
}

Write-Source $target '~/.config/tmux/tmux-config/.tmux.conf'
Write-Source $legacy '~/.config/tmux/tmux.conf'
Write-Output "Installed tmux config in $repoCopy"
