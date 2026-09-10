#!/usr/bin/env bash
#============================================================================
# bootstrap.sh — Bootstrap dotfiles on Linux / macOS
#============================================================================
# Detects stow availability and installs missing packages via the system
# package manager (apt / brew / dnf). Then runs `stow --dotfiles` for the
# cross‑platform package set.  Skips Linux‑only packages unless
# `-IncludeWSL` is given (those are intended for WSL usage).
#
# Usage:
#   ./bootstrap.sh                # standard
#   ./bootstrap.sh -IncludeWSL    # also stow i3, polybar, picom, rofi
#============================================================================

set -euo pipefail

# ---- Helper: install a package if missing ----
install_pkg_apt() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        sudo apt-get update -qq && sudo apt-get install -y "$1"
    else
        echo "Package already installed: $1"
    fi
}

install_pkg_brew() {
    if ! brew list --formula "$1" >/dev/null 2>&1; then
        brew install "$1"
    else
        echo "Package already installed: $1"
    fi
}

install_pkg_dnf() {
    if ! rpm -q "$1" >/dev/null 2>&1; then
        sudo dnf install -y "$1"
    else
        echo "Package already installed: $1"
    fi
}

# ---- Determine package manager ----
PM=""
if command -v apt-get >/dev/null 2>&1; then PM="apt"
elif command -v brew >/dev/null 2>&1; then PM="brew"
elif command -v dnf >/dev/null 2>&1; then PM="dnf"
else
    echo "No supported package manager found (apt/brew/dnf). Install stow and dependencies manually."
    exit 1
fi

# ---- Install stow if missing ----
if ! command -v stow >/dev/null 2>&1; then
    case "$PM" in
        apt)   install_pkg_apt stow ;;
        brew)  install_pkg_brew stow ;;
        dnf)   install_pkg_dnf stow ;;
    esac
fi

# ---- Core cross‑platform packages to stow ----
# These are the packages that work on both Linux and Windows (via bootstrap.ps1).
CORE_PKGS=(bash git vim starship wezterm alacritty yazi emacs)

# ---- Install distro‑specific deps (minimal set) ----
for pkg in ripgrep fzf zoxide; do
    case "$PM" in
        apt)   install_pkg_apt "$pkg" ;;
        brew)  install_pkg_brew "$pkg" ;;
        dnf)   install_pkg_dnf "$pkg" ;;
    esac
done

# ---- Stow the cross‑platform packages ----
STOW_TARGET="$HOME/.config"
for pkg in "${CORE_PKGS[@]}"; do
    if [ -d " $pkg" ]; then
        echo "Stowing: $pkg -> $STOW_TARGET"
        stow --dotfiles --target "$STOW_TARGET" "$pkg"
    else
        echo "Warning: directory $pkg not found in repo; skipping."
    fi
done

# ---- Optional: Linux‑only packages via WSL or native ----
if [[ "$1" == "-IncludeWSL" ]]; then
    WSL_PKGS=(i3 i3status polybar picom rofi)
    echo "WSL mode: stowing Linux‑only packages (i3, polybar, picom, rofi)."
    for pkg in "${WSL_PKGS[@]}"; do
        if [ -d " $pkg" ]; then
            echo "Stowing: $pkg -> $STOW_TARGET"
            stow --dotfiles --target "$STOW_TARGET" "$pkg"
        else
            echo "Warning: directory $pkg not found in repo; skipping."
        fi
    done
else
    echo "Linux‑only packages (i3, polybar, picom, rofi) omitted. Use -IncludeWSL to stow them."
fi

# ---- Final note ----
echo ""
echo "Bootstrap complete.  To activate symlinks run:"
echo "  ./scripts/activate.sh"
echo "To deactivate: ./scripts/deactivate.sh"