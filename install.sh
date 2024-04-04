#!/bin/bash

# install fzf 
git clone --depth 1 https://github.com/junegunn/fzf.git /tmp/fzf-source
starting_dir=$(pwd)
cd /tmp/fzf-source
./install
cd $starting_dir 

# install ripgrep (Using APT! NOTE: Most likely not the latest version )
apt update
apt install ripgrep

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install local Ollama runner
curl -fsSL https://ollama.com/install.sh | sh
ollama run codellama:7b # See https://ollama.com/library/codellama for available models 


