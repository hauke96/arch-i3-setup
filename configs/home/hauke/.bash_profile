#
# ~/.bash_profile
#

# Path to SSH Agents socket file
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Java font anti-aliasing with newer fontconfig version
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

# Needed to work properly with XDG
export KDE_SESSION_VERSION=5

# For ImageMagick's problems with Nvidia+OpenCL
#export MAGICK_OCL_DEVICE=OFF

export ANDROID_HOME=/media/hauke/Android
export GOROOT=/usr/lib/go/
export GOPATH=$HOME/Projekte/go

# For simple-task-manager project
export STM_OAUTH_CONSUMER_KEY="TWaSD2RpZbtxuV5reVZ7jOQNDGmPjDux2BGK3zUy"
export STM_OAUTH_SECRET="a8K9wAU4Z8v8G7ayxnOpjnsLknkW72Txh62Nsu1C"
export STM_DB_USERNAME="stm"
export STM_DB_PASSWORD="geheim"
