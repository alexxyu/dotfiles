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
    alias ls="gls -lhp --color --group-directories-first"
    alias rmds="find . -name \".DS_Store\" -delete"
else
    alias ls="ls -lhp --color --group-directories-first"
fi
alias la="ls -a"
alias cd="z"
alias vim="nvim"
alias cat="bat -p"
alias less="bat"
alias diff="delta"
alias diffy="delta --side-by-side"
alias rg="rg --hidden --glob '!.git'"

# Interactive ripgrep + fzf search
function cs {
    RG_PREFIX="rg --hidden --glob '!.git/' --line-number --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
          echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
          echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}

# Dev aliases
alias code="code -n"
alias nano="nano -ET4"
alias dc="docker compose"
alias lzd="lazydocker"

# Source any other custom aliases
[[ -f "$HOME/.local/.zsh_aliases" ]] && source "$HOME/.local/.zsh_aliases"

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
# Prevent aliases from being substituted when determining completions
setopt COMPLETE_ALIASES

# History
HISTFILE=$HOME/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Enable completion scripts
COMPLETION_DIR=$HOME/.zsh/completion
if [[ ! -d $COMPLETION_DIR ]]; then
    echo "Downloading Docker completion script to $COMPLETION_DIR"
    mkdir -p $COMPLETION_DIR
    curl -fLo $COMPLETION_DIR/_docker https://raw.github.com/felixr/docker-zsh-completion/master/_docker
fi
fpath+=($COMPLETION_DIR)
autoload -Uz compinit && compinit

# Enable completion selections powered by fzf
FZF_TAB_DIR=$HOME/.zsh/fzf-tab
if [[ ! -d "$HOME/.zsh/fzf-tab" ]]; then
    echo "Cloning fzf-tab to $FZF_TAB_DIR"
    git clone https://github.com/Aloxaf/fzf-tab $FZF_TAB_DIR
fi
source $FZF_TAB_DIR/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# switch group using `[` and `]`
zstyle ':fzf-tab:*' switch-group '[' ']'
# use tab to trigger continuous completion
zstyle ':fzf-tab:*' continuous-trigger 'tab'
# general fzf-tab settings
zstyle ':fzf-tab:*' fzf-min-height 15

# preview directory's content with ls when completing commands involving directories
zstyle ':fzf-tab:complete:(cd|z|ls|gls|cp|mv|find|rm|rmdir):*' fzf-preview \
	'ls -ahgGp --color=always --group-directories-first $realpath'
# preview file contents when using file editors or viewers
zstyle ':fzf-tab:complete:(vim|nvim|less|cat|bat):*' fzf-preview \
	'bat --color=always --style=numbers --line-range=:500 $realpath'
# preview man pages
zstyle ':fzf-tab:complete:man:*' fzf-preview \
	'tldr --color=always $word'

# preview git
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $realpath | delta  -w ${FZF_PREVIEW_COLUMNS:-$COLUMNS}'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
    'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
    'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
    'case "$group" in
    "[modified file]") 
		if [[ -d $realpath ]]; then
			ls -ahgGp --color=always --group-directories-first $realpath
		else
			# https://github.com/wfxr/forgit/issues/121#issuecomment-725358145
			git diff $realpath | delta -w ${FZF_PREVIEW_COLUMNS:-$COLUMNS}
		fi
		;;
    "[recent commit object name]")
		git show --color=always $word | delta
		;;
    *)
		git log --color=always $word
		;;
    esac'
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout):*' fzf-flags --height=80% --preview-window=65%:right

# preview docker
zstyle ':fzf-tab:complete:docker-*:*' fzf-preview '(docker inspect $word | jq -C)'
zstyle ':fzf-tab:complete:docker-*:*' fzf-flags --height=80% --preview-window=50%:right
zstyle ':fzf-tab:complete:docker-logs:*' fzf-preview 'docker logs -f $word | bat'

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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=146,underline"

# Keybindings
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
if [[ ! -f "$bat_themes_dir/Catppuccin Latte.tmTheme" ]]; then
    echo "Downloading Catppuccin latte theme for bat"
    curl -o "$bat_themes_dir/Catppuccin Latte.tmTheme" \
        https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Latte.tmTheme
    bat cache --build
fi

if [[ ! -v TERM_BG ]]; then
    if [[ "$(uname)" = "Darwin" ]]; then
        export TERM_BG="${$(defaults read -g AppleInterfaceStyle 2> /dev/null):l}"
    elif [[ "$(uname)" = "Linux" ]]; then
        export TERM_BG="dark"
    fi
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

# powerlevel10k.zsh theme
if [ "$(uname)" = "Darwin" ]; then
    [[ -f $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme ]] && \
        source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
elif [ "$(uname)" = "Linux" ]; then
    [[ -f ~/.local/powerlevel10k/powerlevel10k.zsh-theme ]] && \
        source ~/.local/powerlevel10k/powerlevel10k.zsh-theme
fi
[[ -f ~/.config/powerlevel10k/p10k.zsh ]] && source ~/.config/powerlevel10k/p10k.zsh
[[ -f ~/.config/powerlevel10k/p10k.mise.zsh ]] && source ~/.config/powerlevel10k/p10k.mise.zsh


##################
# Misc. settings #
##################

# Set up shell integrations for misc utils
eval "$(~/.local/bin/mise activate zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"

export LESS="-IFSR --mouse"

# HACK: fix delta autocompletion (https://github.com/dandavison/delta/issues/1167#issuecomment-1678568122)
compdef _gnu_generic delta

# Source custom zshrc config
[[ -f "$HOME/.local/.zshrc" ]] && source "$HOME/.local/.zshrc"

