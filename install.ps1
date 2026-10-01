$ErrorActionPreference = 'Stop'

$repoUrl = 'https://github.com/Mrchazaaa/tmux-config.git'
$installDir = Join-Path $HOME '.config/tmux/tmux-config'
$configPath = Join-Path $HOME '.tmux.conf'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git is required. Install Git for Windows, then rerun this script.'
}

New-Item -ItemType Directory -Force -Path (Split-Path $installDir) | Out-Null

if (Test-Path (Join-Path $installDir '.git')) {
    $pull = Read-Host "Pull the latest changes for $installDir? [y/N]"
    if ($pull -match '^(y|yes)$') {
        git -C $installDir pull --ff-only
    }
}
elseif (Test-Path $installDir) {
    throw "$installDir already exists but is not a Git checkout."
}
else {
    git clone $repoUrl $installDir
}

$sourcePath = (Join-Path $installDir '.tmux.conf').Replace('\', '/')
if (Test-Path $configPath) {
    $backupPath = "$configPath.backup.$(Get-Date -Format yyyyMMddHHmmss)"
    Copy-Item $configPath $backupPath
    Write-Host "Backed up $configPath to $backupPath"
}

[IO.File]::WriteAllText($configPath, "source-file $sourcePath`n", [Text.UTF8Encoding]::new($false))
Write-Host "Installed tmux config from $installDir"
