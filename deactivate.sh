#!/bin/zsh
stow -D --dotfiles bash zsh tmux git
stow -D --dotfiles alacritty -t $HOME/.config/alacritty 
stow -D --dotfiles nvim  -t $HOME/.config/nvim
stow -D --dotfiles i3 -t $HOME/.config/i3
stow -D --dotfiles i3status -t $HOME/.config/i3status
stow -D --dotfiles rofi -t $HOME/.config/rofi 
stow -D --dotfiles starship -t $HOME/.config
stow -D --dotfiles picom -t $HOME/.config
