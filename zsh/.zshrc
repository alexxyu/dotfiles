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
alias cd="z"
alias cat="bat -p"
alias less="bat"
alias diff="delta"
alias diffy="delta --side-by-side"

# Dev aliases
alias code="code -n"
alias nano="nano -ET4"
alias dc="docker compose"
alias lzd="lazydocker"

# Source any other custom aliases
[ -f "$HOME/.local/.zsh_aliases" ] && source "$HOME/.local/.zsh_aliases"

export PATH=$HOME/.local/bin:$PATH

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

# Enable git completion
autoload -Uz compinit && compinit

# Enable completion selections powered by fzf
[ -d "$HOME/.zsh/fzf-tab" ] || git clone https://github.com/Aloxaf/fzf-tab $HOME/.zsh/fzf-tab
source $HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with ls when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls' # 'eza -1 --color=always $realpath'
# switch group using `[` and `]`
zstyle ':fzf-tab:*' switch-group '[' ']'

# Setup zsh plugins: syntax highlighting + autosuggestions
# Allow case-insensitive autocompletion for lowercase characters
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
if [ "$(uname)" = "Darwin" ]; then
    INSTALL_PATH="$(brew --prefix)/share"
else
    INSTALL_PATH="/usr/share"
fi
source $INSTALL_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $INSTALL_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
# bindkey '^I'       complete-word       # tab               | complete
bindkey '^[[Z'     autosuggest-accept  # shift + tab       | autosuggest

# Case-sensitive file sorting
export LC_COLLATE=C
export LANG=en_US.UTF-8
export LC_ALL=$LANG

# Set terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Terminal themes
bat_themes_dir="$(bat --config-dir)/themes"
mkdir -p $bat_themes_dir
if [ ! -f "$bat_themes_dir/Catppuccin Latte.tmTheme" ]; then
    curl -o "$bat_themes_dir/Catppuccin Latte.tmTheme" https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Latte.tmTheme
    bat cache --build
fi

if [[ ! -v TERM_BG && "$(uname)" = "Darwin" ]]; then
    export TERM_BG="${$(defaults read -g AppleInterfaceStyle 2> /dev/null):l}"
fi

if [ "$TERM_BG" = "dark" ]; then
    export BAT_THEME='Dracula'
    export FZF_DEFAULT_OPTS=" \
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
else
    export BAT_THEME='Catppuccin Latte'
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
        --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
        --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
    zstyle ":fzf-tab:*" fzf-flags --color=hl:0
fi

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

# nvm sourcing
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv initialize
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# setup other utils
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"

export LESS="-IFS --mouse"

[ -f "$HOME/.local/.zshrc" ] && source "$HOME/.local/.zshrc"

