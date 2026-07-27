# My Emacs Configuration (Neovim-style IDE)

A literate Emacs configuration designed for people coming from Neovim. 
It focuses on being a fast, usable IDE with Evil, a leader key, modern completion, and strong language support (especially .NET / Critter Stack + Docker).

## Features

- Evil + `SPC` leader key with which-key
- Vertico / Consult / Embark / Company (Telescope-like experience)
- Modular language support (`lisp/lang-*.el`)
- Automatic Tree-sitter grammar installation
- Format-on-save (Apheleia)
- DAP debugging
- Full .NET / Critter Stack support with Docker Compose 
  (automatically detects both **JetBrains Rider** and **Visual Studio** override files)
- Swappable package manager (`package.el` / `straight.el` / `elpaca`)
- Doom-inspired startup & runtime performance optimisations

## Quick Start

1. Place `config.org` in `\~/.emacs.d/`
2. Run `M-x org-babel-tangle` (or `C-c C-v t`)
3. Restart Emacs

## Package Manager
