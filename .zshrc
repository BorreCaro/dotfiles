# Si vienes de bash, quizás necesites cambiar tu $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
plugins=( 
    sudo
    git
    # suse
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# check the suse plugins commands here
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/suse/suse.plugin.zsh

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
#
# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)
source ~/.p10k.zsh
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/directories in terminal using lsd
# alias ls='lsd'
# alias l='ls -l'
# alias la='ls -a'
# alias lla='ls -la'
# alias lt='ls --tree'

eval "$(zoxide init zsh)"
# === FNM Configuration ===
FNM_PATH="/home/dev/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

 #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!

export SDKMAN_DIR="$HOME/.sdkman"

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh" 
