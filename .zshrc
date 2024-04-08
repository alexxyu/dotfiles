###########
# Aliases #
###########

# Python aliases
alias pip="pip3"
function python () {
    test -z "$1" && bpython || python3 "$@";
}
alias pyvenv="source .venv/bin/activate"
alias pycrenv="python -m venv .venv --system-site-packages && actenv"

# Shell aliases
if [ "$(uname)" = "Darwin" ]; then
    alias ls="gls -lh --color --group-directories-first"
    alias rmds="find . -name \".DS_Store\" -delete"
else
    alias ls="ls -lh --color --group-directories-first"
fi
alias la="ls -a"

# Dev aliases
alias code="code -n"
alias nano="nano -ET4"
alias dc="docker-compose"

#####################
# Terminal settings #
#####################

# Disable terminal ctrl-s behavior to allow bpython to save
stty -ixon

# Explicitly set emacs keybindings
set -o emacs
# Show filetypes in autocompletion list
setopt list_types
# Append trailing slash to directories from filename generation (globbing)
setopt mark_dirs

# Allow case-insensitive autocompletion for lowercase characters
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
bindkey '^I'       complete-word       # tab               | complete
bindkey '^[[Z'     autosuggest-accept  # shift + tab       | autosuggest

# Case-sensitive file sorting
export LC_COLLATE=C
export LANG=en_US.UTF-8
export LC_ALL=$LANG

# Set terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Enable git completion
autoload -Uz compinit && compinit

# Stricter definition of word when using word-delete i.e. more bash-like
export WORDCHARS='*?.[]~=&;!#$%^(){}<>'

# Add git branch name to terminal
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%1~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}$ '

##################
# Misc. settings #
##################

