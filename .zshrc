# ╺━┓┏━┓╻ ╻┏━┓┏━╸
# ┏━┛┗━┓┣━┫┣┳┛┃  
# ┗━╸┗━┛╹ ╹╹┗╸┗━╸
# author: Nicola Ferru aka NFVblog

# create ZI direcotory
typeset -Ag ZI
typeset -gx ZI[HOME_DIR]="${HOME}/.zi"
typeset -gx ZI[BIN_DIR]="${HOME}/.zi/bin"
command mkdir -p "$ZI[BIN_DIR]"
# enable zi
typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"
source "${ZI[BIN_DIR]}/zi.zsh"

# eza -> ls
zi ice from'gh-r' as'program' sbin'**/eza -> eza' atclone'cp -vf completions/eza.zsh _eza'
zi light eza-community/eza
# fish mode
zi wait lucid for \
  atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
     z-shell/F-Sy-H \
  blockf \
     zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# apparance
PROMPT='%F{cyan}%n%f@%F{green}%m:%F{yellow}%~%f
$> '
# config
source $HOME/.config/zsh/aliasrc
source $HOME/.config/zsh/env
