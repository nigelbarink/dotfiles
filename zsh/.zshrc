
# attach to an existing tmux session or create a new one if none exist
if [ "$TMUX" = "" ] && [ -z "$TMUX"]; then
	tmux attach -t $(tmux display-message -p '#S') || tmux new-session
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Path to your oh-my-zsh installation.
export ZSH="/home/nigel/.oh-my-zsh"

bindkey -v 
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

ZSH_THEME="lambda"

# Use case-sensitive completion.
CASE_SENSITIVE="true"

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

HIST_STAMPS="dd/mm/yyyy"

# Which plugins would you like to load?
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting tmux debian themes web-search)

source $ZSH/oh-my-zsh.sh

# Add the fzf key-bindings and completions 
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# User configuration
source ~/.bashrc

# Set my language environment
export LANG=en_GB.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Personal aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias dev="cd /home/nigel/Development"
alias dotfiles="cd /home/nigel/.dotfiles"
# Set Environment Variables
DOTNET_ROOT=$HOME/dotnet
PATH=$PATH:$HOME/dotnet
export PATH=$PATH:/home/nigel/Hacking/Development/depot_tools

# Personal Aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

# Add Clang-Tools 
export PATH=$PATH:/usr/local/llvm

# Add nvim 
export PATH=$PATH:/usr/local/bin/nvim/bin:
export PATH=$PATH:/opt/gradle/gradle-8.7/bin

# Add GoLang 
export PATH=$PATH:/usr/local/go/bin


# Add Autocompletion tools
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$word")")

  reply=( "${(ps:\n:)completions}")

}
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh paramater for dotnet cli tab completion
compctl -K _dotnet_zsh_complete dotnet

eval "$(fzf --zsh)"
eval "$(starship init zsh)"

