; set variables
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq inhibit-splash-screen t)
(setq tab-width 4)
(setq custom-file "~/emacs-custom.el")
(setq display-line-numbers 'relative)

; Toggle modes
(ido-mode 1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)

; Install and load packages
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'package)
(use-package catppuccin-theme :ensure)
(use-package magit :ensure)
(use-package paredit :ensure)

; Activate font and theme
(add-to-list 'default-frame-alist '(font .  "SF Mono"))
(set-face-attribute 'default t :font "SF Mono")
(load-theme 'catppuccin :no-confirm)
(setq catppuccin-flavor 'frappe)
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

(load custom-file)
