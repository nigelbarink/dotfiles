# Keybindings

All leader keys use **`SPC`** (Space) in normal / visual state. 
In insert state you can also use **`M-SPC`**.

Local leader is **`,`**.## Leader (`SPC`)

### Top level

| Key | Command | Description |
|-----|---------|-------------|
| `SPC SPC` | `execute-extended-command` | M-x |
| `SPC :` | `eval-expression` | Eval Elisp expression |

### Files (`SPC f`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC f f` | `find-file` | Find file |
| `SPC f r` | `consult-recent-file` | Recent files |
| `SPC f s` | `save-buffer` | Save |
| `SPC f S` | `write-file` | Save as |

### Buffers (`SPC b`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC b b` | `consult-buffer` | Switch buffer |
| `SPC b d` | `kill-current-buffer` | Kill buffer |
| `SPC b n` | `next-buffer` | Next buffer |
| `SPC b p` | `previous-buffer` | Previous buffer |
| `SPC b B` | `ibuffer` | Ibuffer |

### Search (`SPC s`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC s s` | `consult-line` | Search in current buffer |
| `SPC s p` | `consult-ripgrep` | Live grep in project |
| `SPC s f` | `consult-find` | Find file (fd/find) |
| `SPC s i` | `consult-imenu` | Imenu |
| `SPC s I` | `consult-imenu-multi` | Imenu across buffers |

### Project (`SPC p`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC p p` | `project-switch-project` | Switch project |
| `SPC p f` | `project-find-file` | Find file in project |
| `SPC p b` | `project-switch-to-buffer` | Switch to project buffer |
| `SPC p s` | `consult-ripgrep` | Search in project |
| `SPC p c` | `project-compile` | Compile |
| `SPC p !` | `project-shell` | Project shell |

### Windows (`SPC w`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC w w` | `other-window` | Other window |
| `SPC w d` | `delete-window` | Delete window |
| `SPC w /` | `split-window-right` | Vertical split |
| `SPC w -` | `split-window-below` | Horizontal split |
| `SPC w m` | `delete-other-windows` | Maximize window |

### Git (`SPC g`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC g g` | `magit-status` | Magit status |
| `SPC g b` | `magit-blame` | Blame |
| `SPC g l` | `magit-log-current` | Log |

### Code / LSP (`SPC c`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC c a` | `eglot-code-actions` | Code actions |
| `SPC c r` | `eglot-rename` | Rename |
| `SPC c f` | `eglot-format` | Format (Eglot) |
| `SPC c F` | `apheleia-format-buffer` | Format (Apheleia) |
| `SPC c d` | `xref-find-definitions` | Go to definition |
| `SPC c D` | `xref-find-references` | Find references |
| `SPC c h` | `eldoc-doc-buffer` | Documentation |
| `SPC c e` | `flymake-show-buffer-diagnostics` | Diagnostics |
| `SPC c d` | `dap-debug` | Start debugging |
| `SPC c D` | `dap-disconnect` | Disconnect debugger |
| `SPC c b` | `dap-breakpoint-toggle` | Toggle breakpoint |
| `SPC c n` | `dap-next` | Step over |
| `SPC c i` | `dap-step-in` | Step in |
| `SPC c o` | `dap-step-out` | Step out |
| `SPC c c` | `dap-continue` | Continue |

### Open (`SPC o`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC o t` | `vterm` | Terminal |
| `SPC o p` | `treemacs` | File tree |
| `SPC o d` | `dired` | Dired |

### .NET / Docker (`SPC o d`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC o d u` | `my/dotnet-compose-up` | `docker compose up` (with Rider + VS overrides) |
| `SPC o d d` | `my/dotnet-compose-down` | `docker compose down` |
| `SPC o d l` | `my/dotnet-compose-logs` | Follow logs |
| `SPC o d p` | `my/dotnet-compose-ps` | Show services |
| `SPC o d a` | `my/dotnet-docker-attach` | Attach .NET debugger to a Compose service |

### Toggles (`SPC t`)

| Key | Command | Description |
|-----|---------|-------------|
| `SPC t n` | `display-line-numbers-mode` | Line numbers |
| `SPC t t` | `toggle-truncate-lines` | Truncate lines |
| `SPC t f` | `apheleia-mode` | Format-on-save |## Global / Non-leader keybindings

| Key | Command | Description |
|-----|---------|-------------|
| `C-s` | `consult-line` | Search in buffer |
| `C-x b` | `consult-buffer` | Switch buffer |
| `C-x 4 b` | `consult-buffer-other-window` | Switch buffer other window |
| `M-y` | `consult-yank-pop` | Yank pop (kill ring) |
| `M-g g` | `consult-goto-line` | Go to line |
| `M-g i` | `consult-imenu` | Imenu |
| `M-s r` | `consult-ripgrep` | Ripgrep |
| `M-s f` | `consult-find` | Find file |
| `C-.` | `embark-act` | Embark act |
| `C-;` | `embark-dwim` | Embark dwim |
| `C-h B` | `embark-bindings` | Show bindings |
| `C-x g` | `magit-status` | Magit |
| `<escape>` | `keyboard-escape-quit` | Quit / escape |
| `C-n` (insert) | `evil-normal-state` | Go to normal state |
| `C-g` (insert) | `evil-normal-state` | Go to normal state |## Evil

Standard Vim keybindings are available via Evil + evil-collection.## Tips

- Press `SPC` and wait a moment → which-key popup appears.
- In a .NET project with `docker-compose.yml`, use `SPC o d u` then `SPC o d a` to attach the debugger.

