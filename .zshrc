# ~/.zshrc

# If you use a framework like Oh My Zsh or Antigen/Antibody/Zinit,
# your configuration for themes and plugins will go there.
# Example for Oh My Zsh:
# export ZSH="/home/bobby/.oh-my-zsh"
# ZSH_THEME="agnoster" # Or another theme, can be customized
# plugins=(git atuin sudo ...)
# source $ZSH/oh-my-zsh.sh

# If NOT using a framework, or for manual setup:
# Path
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases
alias ls='ls -p --color=auto'
alias ll='ls -lAh --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
# alias vim='nvim'

# Starship prompt (Recommended for consistency with Fish)
# Make sure Starship is installed: `sudo pacman -S starship`
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Atuin init
# Make sure Atuin is installed: `sudo pacman -S atuin`
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)" # Disable up-arrow if you want to keep default Zsh history search on up
fi
# Optionally, bind Ctrl+R to Atuin's TUI if you prefer it over fzf or default
# bindkey '^R' _atuin_search_widget # Needs atuin 0.13+ and proper widget setup or use their recommended fzf binding

# fzf keybindings (if you have fzf installed)
# Source fzf's keybindings and auto-completion
# [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Zsh syntax highlighting (if not using a framework that provides it)
# Source: /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Zsh auto suggestions (Fish-like)
# Source: /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# LS_COLORS (for `ls` and other tools that use it)
# If you install `vivid` (sudo pacman -S vivid), you can generate LS_COLORS
# eval "$(vivid generate gruvbox-dark)" # Or your preferred Vivid theme that matches
# Or use a predefined LS_COLORS scheme for Gruvbox.

# For a truly minimal prompt without Starship (harder to get exact Gruvbox shades)
# autoload -U promptinit; promptinit
# PS1="%{%F{244}%}%n@%m%{%f%} %{%F{blue}%}%~%{%f%} %# " # Example basic prompt

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory incappendhistory
setopt histignorealldups histignoredups histignorespace

. "$HOME/.atuin/bin/env"
