#!/bin/bash


install_antigen=$1

# Install antigen 
if [[ -n "$install_antigen" ]]; then
    brew install antigen
fi


# To activate antigen, add the following to your ~/.zshrc:
#    source $(brew --prefix)/share/antigen/antigen.zsh
cat <<EOF > ~/.zshrc 
source $(brew --prefix)/share/antigen/antigen.zsh

# Load oh-my-zsh library
antigen use oh-my-zsh

# Load bundles from the default repo (oh-my-zsh)
antigen bundle git
antigen bundle command-not-found
antigen bundle docker

# Load bundles from external repos
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# Select theme
#antigen theme jonathan
antigen theme bira

# Tell Antigen that you're done
antigen apply
EOF

# Prompt to restart the window
echo "Please close the terminal and reopen again."