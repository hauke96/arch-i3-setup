#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Add default key to ssh-agent for git and stuff
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
	echo -n
}

ssh-add -l | grep "4096 SHA256:M40DuLixU97SpvAqu02Il0jKthxDT5T9xwgC8iczBYU /home/hauke/.ssh/id_rsa (RSA)" &>/dev/null
if [ "$?" == 1 ]; then
	ssh-add
	if [ "$?" != 0 ]; then
		exit 1
	fi
fi

# For GPG pinentry-tty
#export GPG_TTY=$(tty)

export ANDROID_HOME=/media/hauke/Android

export GOROOT=/usr/lib/go/
export GOPATH=$HOME/Projekte/go
#export GOPATH=$GOPATH:$HOME/Projekte/Java/OrionSpur-Prototype/server

# For ImageMagick's problems with Nvidia+OpenCL
#export MAGICK_OCL_DEVICE=OFF

# Use Steam's Proton as wine
export W="/home/hauke/.steam/steam/steamapps/common/Proton 3.16/dist"
export WINEVERPATH=$W
export PATH=$W/bin:$PATH
export WINESERVER=$W/bin/wineserver
export WINELOADER=$W/bin/wine
export WINEDLLPATH=$W/lib/wine/fakedlls
export LD_LIBRARY_PATH="$W/lib:$LD_LIBRARY_PATH"
export WINEPREFIX=~/.steam/steam/steamapps/compatdata/243360/pfx

# For simple-task-manager project
export OAUTH_CONSUMER_KEY="TWaSD2RpZbtxuV5reVZ7jOQNDGmPjDux2BGK3zUy"
export OAUTH_SECRET="a8K9wAU4Z8v8G7ayxnOpjnsLknkW72Txh62Nsu1C"
export STM_DB_USERNAME="stm"
export STM_DB_PASSWORD="geheim"
alias stm-t='ssh -p 28251 root@stm-test.hauke-stieler.de'
alias stm='ssh -p 17642 stm@stm.hauke-stieler.de'

alias wine='~/.steam/steam/steamapps/common/Proton\ 3.16/dist/bin/wine'

alias ls='ls --color=auto'
alias ll='ls -alh --color=always'
#alias ll='lsd --long --classify --all --group-dirs first'
#alias ls='ll --sizesort'
#alias grep='grep --color=always'
alias search='git grep --no-index -HIpn'

#alias photoshop='wine /media/programme/Programme/Photoshop/Adobe\ Photoshop\ CS5\ \(64\ Bit\)/Photoshop.exe'
alias http='python3 -m http.server'

# For dotfiles
alias cfg='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

#alias update='echo DENK AN DIE IgnorePkg!!!; echo; echo; sudo pacman -Syu'

# Update and shutdown
alias upd='sudo bash -c "pacman -Syu && shutdown -h now"'

#PS1='[\u@\h \W]\$ '
#green="$(echo -e "\033[01;32m")"
#blue="$(echo -e "\033[01;34m")"
#red="$(echo -e "\033[1;31m")"
#def="$(echo -e "\033[1;00m")"
green="\[\033[01;32m\]"
blue="\[\033[01;34m\]"
red="\[\033[1;31m\]"
def="\[\033[1;00m\]"
#symb_up=$'\U25B2'
#symb_down=$'\U25BC'

#symb_up=$'\U1F805'
#symb_down=$'U25BD'

symb_up=$'\U2191'
symb_down=$'\U2193'
symb_dot=$'\U2022'

function git_has_changes()
{
	c=""
	if [ -n "$(git diff HEAD 2>/dev/null)" ]
	then
		c=" $symb_dot"
	fi

	echo -n "$c"
}

function git_tracked()
{
	# Determine amount of untracked files
	u=""
	untracked_count="$(git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' 2>/dev/null | wc -l)"
	if [ $untracked_count -ne 0 ]
	then
		u=" +$untracked_count"
	fi

	echo -n "$u"
}

function git_ahead()
{
	# Determine number of commits ahead/behind
	p=""
	name="$(__git_ps1 '%s')"
	count="$(git rev-list --count --left-right remotes/origin/$name...$name 2>/dev/null)"
	case "$count" in
		"") # no upstream
			p="" ;;
		"0	0") # equal to upstream
			p="" ;;
		"0	"*) # ahead of upstream
			p=" $symb_up${count#0	}" ;;
		*"	0") # behind upstream
			p=" $symb_down${count%	0}" ;;
		*)	    # diverged from upstream
			p=" $symb_up${count#*	} $symb_down${count%	*}" ;;
	esac

	echo -n "$p"
}

function ps1()
{
	history -a
	if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
	then
		source /usr/share/git/completion/git-prompt.sh

		export PS1="$green\u@\h$blue \W \$$def $red$(__git_ps1 "(%s$(git_has_changes)$(git_tracked)$(git_ahead))")$def "
	else
		export PS1="$green\u@\h$blue \w \$$def "
	fi
}

PROMPT_COMMAND=ps1

# remember the last [...] commands in history
HISTSIZE=-1
