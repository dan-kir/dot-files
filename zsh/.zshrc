# Set path if required
#export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

export EDITOR="nvim"
export VISUAL="nvim"
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

gpgconf --launch gpg-agent

# Terminal cursor speed
xset r rate 350 70

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias ec='$EDITOR $HOME/.zshrc' # edit .zshrc
alias sc='source $HOME/.zshrc'  # reload zsh configuration
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -vI'
alias mkdir='mkdir -pv'
alias history='fc -l 1'

# Hardened_malloc Aliases
alias nvim="LD_PRELOAD='/usr/lib/libhardened_malloc.so/libhardened_malloc.so' nvim"
alias tmux="LD_PRELOAD='/usr/lib/libhardened_malloc.so/libhardened_malloc.so' tmux"
alias ssh="LD_PRELOAD='/usr/lib/libhardened_malloc.so/libhardened_malloc.so' ssh"
alias ranger="LD_PRELOAD='/usr/lib/libhardened_malloc.so/libhardened_malloc.so' ranger"
alias curl="LD_PRELOAD='/usr/lib/libhardened_malloc.so/libhardened_malloc.so' curl"
alias wget="LD_PRELOAD='/usr/lib/libhardened_malloc.so/libhardened_malloc.so' wget"

# Use vi keybindings even if our EDITOR is set to vi
bindkey -e

setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

# Keep 500000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=50000000
SAVEHIST=${HISTSIZE}
HISTFILESIZE=500000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

#autoload -Uz promptinit
#promptinit
#prompt clint
autoload -U colors && colors
#PROMPT='%F{blue}%n%F{red}@%F{blue}%m:%F{white}%d$ %F{reset}'
PS1="%B%{$fg[red]%}[%{$fg[blue]%}%n%{$fg[red]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# zplug - manage plugins
source /usr/share/zplug/init.zsh
#zplug "plugins/git", from:oh-my-zsh
#zplug "plugins/sudo", from:oh-my-zsh
#zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
#zplug "junegunn/fzf"
#zplug "themes/robbyrussell", from:oh-my-zsh, as:theme   # Theme

# zplug - install/load new plugins when zsh is started or reloaded
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

function secret {  # list preferred id last
  output="${HOME}/$(basename ${1}).$(date +%F).enc"
  gpg --encrypt --armor \
    --output ${output} \
    -r 0x8888888888888888 \
    -r email@mail.com \
    "${1}" && echo "${1} -> ${output}" }

function reveal {
  output=$(echo "${1}" | rev | cut -c16- | rev)
  gpg --decrypt --output ${output} "${1}" \
    && echo "${1} -> ${output}" }

function gpg_restart {
  pkill gpg
  pkill pinentry
  pkill ssh-agent
  eval $(gpg-agent --daemon --enable-ssh-support) }

function dump_arp {
  ${ROOT} tcpdump -eni ${NETWORK} -w arp-${NOW}.pcap \
    "ether proto 0x0806" }

function dump_icmp {
  ${ROOT} tcpdump -ni ${NETWORK} -w icmp-${NOW}.pcap \
    "icmp" }

function dump_syn {
  ${ROOT} tcpdump -ni ${NETWORK} -w syn-${NOW}.pcap \
    "tcp[13] & 2 != 0" }

function dump_udp {
  ${ROOT} tcpdump -ni ${NETWORK} -w udp-${NOW}.pcap \
    "udp and not port 443" }
