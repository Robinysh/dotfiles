unset SUDO_UID SUDO_GID SUDO_USER

#xrdb $HOME/.Xresources
export LANG=en_US.UTF-8
export LC_MESSAGE="C"

alias ls="ls --color=auto"
alias ll="ls -l"
alias l="ls -lh"
alias la="ls -a"
alias df="df -h"
alias cl="clear"
alias sf="screenfetch"
alias r="ranger"
alias battery="cat /sys/class/power_supply/BAT0/capacity"
alias mountftp="curlftpfs upload:thinkquantum@cuphysoc.com ~/media/ftp/"
alias umountftp="fusermount -u ~/media/ftp"
alias ...="../../"
alias ....="../../../"

autoload -Uz compinit
compinit

zstyle ":completion:*" menu select
setopt COMPLETE_ALIASES


export CPATH="$CPATH:/opt/cuda/include:/opt/intel/vtune_amplifier_2018.1.0.535340/include"
export PATH="$PATH:/opt/cuda/bin:$HOME/.local/bin:/opt/intel/vtune_amplifier_2018.1.0.535340/bin64:/opt/intel/bin:/data/Matlab/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib:/opt/cuda/lib64:/opt/cuda/extras/CUPTI/lib64:/usr/local/lib:$HOME/.local/lib:/usr/lib32:/opt/intel/vtune_amplifier_2018.1.0.535340/lib32:/opt/intel/vtune_amplifier_2018.1.0.535340/lib64:/opt/intel/lib"
export CUDA_HOME="/opt/cuda:$CUDA_HOME"
export JAVA_HOME=/usr/lib/jvm/default 
#export XDG_CACHE_HOME=/var/cache


#export TERM='rxvt-unicode-256color'
export TERM='xterm-256color'
export COLORTERM='rxvt-unicode-256color'
export BROWSER=google-chrome-stable
#export PACMAN=powerpill
alias mountntfs="sudo mount -t ntfs /dev/sda1 /media/ -o umask=002"
alias cx="xclip -selection c"
alias vx="xclip -selection clipboard -o"

alias sshligo="ssh shingheirobin.yuen@ssh.ligo.org"
alias sshcluster2="ssh ppc1816@cluster2.phy.cuhk.edu.hk"
alias sshcluster2old="ssh ppc1719@cluster2.phy.cuhk.edu.hk"
alias sshiucaa="ssh shingheirobin.yuen@ldas-grid.gw.iucaa.in"

function scptoligo {
    gsiscp -r $2 $1:~/scp
}

function scpgetligo {
    gsiscp -r $1:$2 ~/scp
}

alias scptoiucaa="scptoligo iucaa"
alias scptoldas="scptoligo ldas"

alias scpgetiucaa="scpgetligo iucaa"
alias scpgetldas="scpgetligo ldas"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export WINEPREFIX=$HOME/wineprefix
export WINEARCH=win32

alias reloadxresources="xrdb -load ~/.Xresources"

#Bind vi mode
bindkey -v
export KEYTIMEOUT=1


export LESS_TERMCAP_mb=$'\e[0;31m'      # less start blink escape sequence
export LESS_TERMCAP_md=$'\e[0;34m'      # less start bold escape sequence
export LESS_TERMCAP_me=$'\e[0m'         # less end bold, blink, and underline
export LESS_TERMCAP_se=$'\e[0m'         # less stop standout escape sequence
export LESS_TERMCAP_so=$'\e[0;34;36m'   # less start standout escape sequence
export LESS_TERMCAP_ue=$'\e[0m'         # less stop underline escape sequence
export LESS_TERMCAP_us=$'\e[0;35m'      # less start underline escape sequence


# {{{ PROMPT
autoload -Uz promptinit && promptinit


prompt elite
function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
function parse_current_dir {
    ruby -e "puts ('../'+Dir.getwd.split('/').last(2).join('/')).gsub('//', '/')"
}

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown
# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment 246 235 "%(!.%{%F{yellow}%}.)$USER@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment 172 black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        prompt_segment yellow green
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 239 248 '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
bindkey "^?" backward-delete-char
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "\^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix


#ssh host autocomplete
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

#conda
. /etc/profile.d/conda.sh

export SAVEHIST="1000"
export HISTFILE="$HOME/.zsh_history"
stty -ixon
