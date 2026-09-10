#!/usr/bin/env bash
#============================================================================
# install.sh — One-liner install: clone dotfiles and run Linux bootstrap
#============================================================================
# Usage:
#   curl -fsSL https://gitea.barink.dev/Nigel/dotfiles/raw/main/install.sh | bash
#
# This script:
# 1. Clones the repo to $HOME/.dotfiles if not already present.
# 2. Runs bootstrap.sh to install packages and symlinks.

set -euo pipefail

RepoUrl='https://gitea.barink.dev/Nigel/dotfiles.git'
Target="$HOME/.dotfiles"

if [ ! -d "$Target" ]; then
    Write-Host "Cloning dotfiles to $Target ..." >&2
    git clone "$RepoUrl" "$Target"
fi

Write-Host "Running bootstrap.sh ..." >&2
bash "$Target/bootstrap.sh"

Write-Host "`nInstall complete. To activate symlinks run: ./scripts/activate.sh" >&2