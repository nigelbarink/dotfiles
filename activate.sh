#!/bin/zsh
stow --dotfiles bash zsh tmux git
mkdir -p $HOME/.config/nvim && stow --dotfiles nvim -t $HOME/.config/nvim  
mkdir -p $HOME/.config/alacritty && stow --dotfiles alacritty  -t $HOME/.config/alacritty
mkdir -p $HOME/.config/i3 && stow --dotfiles i3 -t $HOME/.config/i3 
mkdir -p $HOME/.config/i3status && stow --dotfiles i3status -t $HOME/.config/i3status
mkdir -p $HOME/.config/rofi && stow --dotfiles rofi -t $HOME/.config/rofi
stow --dotfiles starship -t $HOME/.config
