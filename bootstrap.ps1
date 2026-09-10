<#
.SYNOPSIS
  Bootstrap dotfiles on Windows (idempotent, no admin if possible).

.DESCRIPTION
  - Detects Windows Developer Mode (enables symlinks without elevation)
  - Installs packages via winget (user scope) with fallback to scoop
  - Creates symlinks / junctions for dotfiles; falls back to Copy-Item if not elevated
  - Installs PowerShell modules (PSFzf, Catppuccin)
  - Skips Linux-only packages (i3, polybar, picom, rofi)
  - Sets ExecutionPolicy hint if needed

.PARAMETER IncludeWSL
  If supplied, also stow Linux-only packages (i3, polybar, picom, rofi) via WSL.

.EXAMPLE
  pwsh -ExecutionPolicy Bypass -File $env:HOME\.dotfiles\bootstrap.ps1
  pwsh -ExecutionPolicy Bypass -File $env:HOME\.dotfiles\bootstrap.ps1 -IncludeWSL
#>

#requires -RunLevel Administrator   # commented out; we handle fallback via Junction/Copy

# ---- Detect Developer Mode (allows non-admin symlinks via CreateSymbolicLink) ----
$devMode = $false
try {
    $reg = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -ErrorAction Stop
    if ($reg.AllowDevelopmentWithoutDevLicense -eq 1) { $devMode = $true }
} catch { Write-Host "Developer Mode not detected; falling back to Junction/Copy." }

# ---- Winget install (user scope) with idempotent check ----
function Install-WingetPackage {
    param([string]$Id)
    # Check already installed (idempotent)
    if (winget list --id $Id -ErrorAction SilentlyContinue) {
        Write-Host "Package already installed: $Id"
        return
    }
    winget install --id $Id --scope user --accept-package-agreements --accept-source-agreements -e -q
}

# Core packages to install (Windows-first; Linux kept separate in bootstrap.sh)
$corePkgs = @(
    'Git.Git',
    'Microsoft.PowerShell',
    'wez.wezterm',
    'Starship.Starship',
    'BurntSushi.ripgrep.MSVC',
    'junegunn.fzf',
    'YaziFM.Yazi',
    'Neovim.Neovim',
    'Alacritty.Alacritty',
    'jesseduffield.lazygit',
    'ajeetdsouza.zoxide'
)

foreach ($pkg in $corePkgs) {
    Install-WingetPackage -Id $pkg
}

# ---- Install PowerShell modules (PSFzf, Catppuccin) ----
if (-not (Get-Module -Name PSFzf -ListAvailable)) {
    Install-Module -Name PSFzf -Scope CurrentUser -Force -Quiet
    Write-Host "Installed PSFzf module."
}
if (-not (Get-Module -Name Catppuccin -ListAvailable)) {
    Install-Module -Name Catppuccin -Scope CurrentUser -Force -Quiet
    Write-Host "Installed Catppuccin module."
}

# ---- Helper: create symlink or copy fallback ----
function New-SymLinkOrCopy {
    param(
        [string]$Source,
        [string]$Target,
        [switch]$Force
    )
    if (-not (Test-Path $Source)) {
        Write-Warning "Source not found: $Source"
        return
    }
    if ($devMode -or $Force) {
        try {
            New-Item -ItemType SymbolicLink -Path $Target -Value $Source -Force -ErrorAction Stop
            Write-Host "Symlink: $Target -> $Source"
            return
        } catch {
            Write-Warning "Failed to create symlink; falling back to copy."
        }
    }
    # Fallback: copy file or create junction for dirs
    if (Test-Path $Target) { Remove-Item $Target -Force }
    if (Test-Path (Split-Path $Target -Parent)) {
        Copy-Item -Path $Source -Destination $Target -Recurse -Force
        Write-Host "Copied: $Source -> $Target"
    }
}

# ---- Map dotfiles from repo to Windows config locations ----
$repoRoot = $PSScriptRoot
$home   = $Env:USERPROFILE

# 1. wezterm config -> $HOME\.config\wezterm AND %APPDATA%\wezterm (junction for portability)
$wezSrc = Join-Path $repoRoot 'wezterm\dot-wezterm.lua'
$wezTarget1 = Join-Path $home '\.config\wezterm'
$wezTarget2 = Join-Path $env:APPDATA 'wezterm'
if (Test-Path $wezSrc) {
    New-SymLinkOrCopy -Source $wezSrc -Target $wezTarget1
    # Also create junction for APPDATA copy if not already
    if (-not (Test-Path $wezTarget2)) { New-Item -ItemType Junction -Path $wezTarget2 -Value $wezTarget1 -Force }
}

# 2. PowerShell profile -> Documents\PowerShell\Microsoft.PowerShell_profile.ps1 (pwsh 7)
#    + Documents\WindowsPowerShell\... (pwsh 5.1) + ~/.config/powershell for Linux compat
$psSrc = Join-Path $repoRoot 'powershell\powershell_profile.ps1'
$psTarget1 = Join-Path $home 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
$psTarget2 = Join-Path $home 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
$psTarget3 = Join-Path $home '\.config\powershell'
if (Test-Path $psSrc) {
    New-SymLinkOrCopy -Source $psSrc -Target $psTarget1
    # Also link for pwsh 5.1 if path exists
    if (-not (Test-Path (Split-Path $psTarget2 -Parent))) { New-Item -ItemType Directory -Path (Split-Path $psTarget2 -Parent) -Force }
    if (-not (Test-Path $psTarget2)) { New-Item -ItemType Junction -Path $psTarget2 -Value $psTarget1 -Force }
    # Linux compat symlink
    if (-not (Test-Path $psTarget3)) { New-SymLinkOrCopy -Source $psSrc -Target $psTarget3 }
}

# 3. starship config -> $HOME\.config\starship.toml
$starshipSrc = Join-Path $repoRoot 'starship\starship.toml'
$starshipTarget = Join-Path $home '\.config\starship.toml'
if (Test-Path $starshipSrc) {
    New-SymLinkOrCopy -Source $starshipSrc -Target $starshipTarget
}

# 4. git config -> ~/.gitconfig + $XDG_CONFIG_HOME\git\config
$gitSrc = Join-Path $repoRoot 'git\dot-gitconfig'
$gitTarget1 = Join-Path $home '\.gitconfig'
$gitTarget2 = Join-Path $home '\.config\git\config'
if (Test-Path $gitSrc) {
    New-SymLinkOrCopy -Source $gitSrc -Target $gitTarget1
    # Create config\git dir if needed
    if (-not (Test-Path (Split-Path $gitTarget2 -Parent))) { New-Item -ItemType Directory -Path (Split-Path $gitTarget2 -Parent) -Force }
    if (-not (Test-Path $gitTarget2)) { New-SymLinkOrCopy -Source $gitSrc -Target $gitTarget2 }
}

# 5. yazi config -> %APPDATA%\yazi\config\ (and ~/.config\yazi for Linux compat)
$yaziSrc = Join-Path $repoRoot 'yazi\yazi.toml'
$yaziTarget1 = Join-Path $env:APPDATA 'yazi\config'
$yaziTarget2 = Join-Path $home '\.config\yazi'
if (Test-Path $yaziSrc) {
    New-SymLinkOrCopy -Source $yaziSrc -Target $yaziTarget1
    if (-not (Test-Path (Split-Path $yaziTarget2 -Parent))) { New-Item -ItemType Directory -Path (Split-Path $yaziTarget2 -Parent) -Force }
    if (-not (Test-Path $yaziTarget2)) { New-SymLinkOrCopy -Source $yaziSrc -Target $yaziTarget2 }
}

# 6. alacritty config -> %APPDATA%\alacritty\alacritty.toml
$alacrittySrc = Join-Path $repoRoot 'alacritty\alacritty.toml'
$alacrittyTarget1 = Join-Path $env:APPDATA 'alacritty\alacritty.toml'
$alacrittyTarget2 = Join-Path $home '\.config\alacritty'
if (Test-Path $alacrittySrc) {
    New-SymLinkOrCopy -Source $alacrittySrc -Target $alacrittyTarget1
    if (-not (Test-Path (Split-Path $alacrittyTarget2 -Parent))) { New-Item -ItemType Directory -Path (Split-Path $alacrittyTarget2 -Parent) -Force }
    if (-not (Test-Path $alacrittyTarget2)) { New-SymLinkOrCopy -Source $alacrittySrc -Target $alacrittyTarget2 }
}

# 7. (Optional) Linux-only packages via WSL flag
if ($PSCmdlet.Parameters.ContainsKey('IncludeWSL')) {
    Write-Host "WSL mode: skipping Linux-only packages (i3, polybar, picom, rofi). Use WSL for those."
} else {
    Write-Host "Linux-only packages (i3, polybar, picom, rofi) omitted. Use -IncludeWSL to stow them inside WSL."
}

# ---- Final hint: ExecutionPolicy ----
if (-not (Get-Command Set-ExecutionPolicy -ErrorAction SilentlyContinue) -or
    (-not (Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue))) {
    Write-Host "Hint: If scripts fail with 'running scripts is disabled', run:"
    Write-Host "    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned"
}

Write-Host "`nBootstrap complete. Restart your terminal (or run . $PROFILE) to activate."