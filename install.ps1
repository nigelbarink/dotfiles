<#
.SYNOPSIS
  One-liner install: clone dotfiles (if missing) and run Windows bootstrap.

.DESCRIPTION
  Usage (PowerShell):
    curl -fsSL https://gitea.barink.dev/Nigel/dotfiles/raw/main/install.ps1 | powershell

  This script:
  1. Clones the repo to $env:USERPROFILE\.dotfiles if not already present.
  2. Runs bootstrap.ps1 to install packages, create symlinks, etc.
#>

param($RepoUrl='https://gitea.barink.dev/Nigel/dotfiles.git')
$Target = "$env:USERPROFILE\.dotfiles"

if (-not (Test-Path $Target)) {
    Write-Host "Cloning dotfiles to $Target ..."
    git clone "$RepoUrl" "$Target"
}

# Run the Windows bootstrap
Write-Host "Running bootstrap.ps1 ..."
& "$Target\bootstrap.ps1"

Write-Host "`nInstall complete. Restart your terminal (or run . \$PROFILE) to activate."