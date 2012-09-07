# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source /etc/bash_completion.d/git

PATH="$PATH:~/bin"

# setup color variables
color_is_on=
color_red=
color_green=
color_yellow=
color_blue=
color_white=
color_gray=
color_bg_red=
color_off=
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_is_on=true
    color_red="\[$(/usr/bin/tput setaf 1)\]"
    color_green="\[$(/usr/bin/tput setaf 2)\]"
    color_yellow="\[$(/usr/bin/tput setaf 3)\]"
    color_blue="\[$(/usr/bin/tput setaf 6)\]"
    color_white="\[$(/usr/bin/tput setaf 7)\]"
    color_gray="\[$(/usr/bin/tput setaf 8)\]"
    color_off="\[$(/usr/bin/tput sgr0)\]"
    color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
    color_error_off="$(/usr/bin/tput sgr0)"
fi

function prompt_command {
    local PS1_GIT=
    local PWDNAME=$PWD

    # get cursor position and add new line if we're not in first column
    echo -en "\033[6n" && read -sdR CURPOS
    [[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}.${color_error_off}"

    # set title
    echo -ne "\033]0;${USER}@${LOCAL_HOSTNAME}:${PWDNAME}"; echo -ne "\007"

    # set escape sequence for screen to determine window title
    echo -n -e "\033k\033\\"

    # beautify working firectory name
    if [ $HOME == $PWD ]; then
        PWDNAME="~"
    elif [ $HOME ==  ${PWD:0:${#HOME}} ]; then
        PWDNAME="~${PWD:${#HOME}}"
    fi

    # parse git status and get git variables
    parse_git_status

    # build b/w prompt for git
    [[ ! -z $GIT_BRANCH ]] && PS1_GIT=" (${GIT_BRANCH})"

    local color_user=
    if $color_is_on; then
        # set user color
        case `id -u` in
            0) color_user=$color_red ;;
            *) color_user=$color_green ;;
        esac

        # build git status for prompt
        if [ ! -z $GIT_BRANCH ]; then
            if [ -z $GIT_DIRTY ]; then
                PS1_GIT=" (${color_green}${GIT_BRANCH}${color_off})"
            else
                PS1_GIT=" (${color_red}${GIT_BRANCH}${color_off})"
            fi
        fi
    fi

    # set new color prompt
    PS1="${color_user}${USER}${color_off}@${color_yellow}${HOSTNAME}${color_off}:${color_white}${PWDNAME}${color_off}${PS1_GIT} \$ "
}
PROMPT_COMMAND=prompt_command

# get git status
function parse_git_status {
    # clear git variables
    GIT_BRANCH=
    GIT_DIRTY=

    # exit if no git found in system
    local GIT_BIN=$(which git 2>/dev/null)
    [[ -z $GIT_BIN ]] && return

    # check we are in git repo
    local CUR_DIR=$PWD
    while [ ! -d ${CUR_DIR}/.git ] && [ ! $CUR_DIR = "/" ]; do CUR_DIR=${CUR_DIR%/*}; done
    [[ ! -d ${CUR_DIR}/.git ]] && return

    # 'git repo for dotfiles' fix: show git status only in home dir and other git repos
    [[ $CUR_DIR == $HOME ]] && [[ $PWD != $HOME ]] && return

    # get git branch
    GIT_BRANCH=$($GIT_BIN symbolic-ref HEAD 2>/dev/null)
    [[ -z $GIT_BRANCH ]] && return
    GIT_BRANCH=${GIT_BRANCH#refs/heads/}

    # get git status
    local GIT_STATUS=$($GIT_BIN status --porcelain 2>/dev/null)
    [[ -n $GIT_STATUS ]] && GIT_DIRTY=true
}
