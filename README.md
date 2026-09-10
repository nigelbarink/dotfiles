# My dotfiles

Using GNU stow tools to symlink to the home directory.  Cross‑platform:
Linux (Debian/Ubuntu) and Windows (via PowerShell bootstrapper).

---

## Quick start

### Linux

```bash
git clone <url> ~/.dotfiles
cd ~/.dotfiles
# Install prerequisites (stow, zsh, git, curl, etc. — see bootstrap.sh)
./bootstrap.sh
./scripts/activate.sh          # symlink all packages
# optional: ./scripts/deactivate.sh  to remove symlinks
```

### Windows

```powershell
git clone <url> $env:USERPROFILE\.dotfiles
pwsh -ExecutionPolicy Bypass -File $env:USERPROFILE\.dotfiles\bootstrap.ps1
# (optional) pwsh -ExecutionPolicy Bypass -File $env:USERPROFILE\.dotfiles\bootstrap.ps1 -IncludeWSL
# Then launch wezterm / starship / yazi etc. as normal.
```

---

## Bootstrap scripts

- `bootstrap.sh` (Linux / macOS) – detects `stow` availability and installs missing
  packages via `apt`/`brew`/`dnf`, then runs `stow --dotfiles` for the
  cross‑platform package set.  Skips Linux‑only packages (`i3`, `polybar`,
  `picom`, `rofi`) unless `-IncludeWSL` is given.

- `bootstrap.ps1` (Windows) – the primary ease‑of‑use entry point.  It

  1. Detects Windows Developer Mode (symlinks without admin elevation).
  2. Installs packages via `winget` (user scope) with idempotent checks.
  3. Installs PowerShell modules (`PSFzf`, `Catppuccin`).
  4. Creates symlinks / junctions for dotfiles; falls back to `Copy-Item`
     if not elevated or Developer Mode is off.
  5. Maps repo files to Windows config locations (`wezterm`, `powershell`,
     `starship`, `git`, `yazi`, `alacritty`).
  6. Skips Linux‑only packages (`i3`, `polybar`, `picom`, `rofi`) by default;
     use `-IncludeWSL` to stow them inside WSL.

---

## Packages overview

| Package | Cross‑platform? | Windows default? | Linux‑only |
|---------|-----------------|------------------|-----------|
| `wezterm` | ✅ | ✅ (via bootstrap.ps1) | — |
| `starship` | ✅ | ✅ | — |
| `git` | ✅ | ✅ | — |
| `vim` | ✅ | ✅ | — |
| `emacs` | ✅ | ✅ | — |
| `alacritty` | ✅ | ✅ | — |
| `yazi` | ✅ | ✅ | — |
| `powershell` | ✅ (primary) | ✅ | — |
| `zsh` | WSL only | — | ✅ (via bootstrap.sh) |
| `bash` | WSL only | — | ✅ (via bootstrap.sh) |
| `tmux` | WSL only | — | ✅ (via bootstrap.sh) |
| `i3` | — | — | ✅ (X11, via `-IncludeWSL`) |
| `polybar` | — | — | ✅ (via `-IncludeWSL`) |
| `picom` | — | — | ✅ (via `-IncludeWSL`) |
| `rofi` | — | — | ✅ (via `-IncludeWSL`) |

---

## Post‑install

- Restart your terminal (or run `. $PROFILE`) so PowerShell modules take effect.
- Run `doctor` (conceptual) to verify all links and installed packages.
- Use `./scripts/activate.sh` / `./scripts/deactivate.sh` to toggle symlinks.
- On Windows, the PowerShell profile (`$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`) is auto‑sourced by `pwsh`.

---

## Resources

- [managing dotfiles](https://www.jakewiesler.com/blog/managing-dotfiles)
- [Using Git to manage your dotfiles](https://blog.smalleycreative.com/using-git-and-github-to-manage-your-dotfiles)