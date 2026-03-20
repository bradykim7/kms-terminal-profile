# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export TERM=xterm-256color

ZSH_THEME="aphrodite"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

# eza theme
export EZA_CONFIG_DIR="$HOME/.config/eza"

# --- Aliases: Navigation ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons -snew'
alias la='eza -a --icons'
alias l='eza -l --icons'
alias lssize='eza -lS --total-size --sort=size'
alias tree='eza --tree'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'

# --- Aliases: File Preview & Search ---
alias cat='bat'
alias findf='fzf'
alias grep='rg'
alias search='rg'
alias f='rg --files | fzf'
alias ff='rg --no-heading --line-number'

# --- Aliases: System ---
alias updatebrew='brew update && brew upgrade && brew cleanup'
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='ipconfig getifaddr en0'
alias myip='curl ifconfig.me'
alias please='sudo $(fc -ln -1)'
alias usage='du -sh * | sort -h'

# --- Aliases: Git ---
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gb='git branch'
alias gcb='git checkout -b'
alias gstash='git stash'
alias gstashpop='git stash pop'
alias gd='git diff'

# --- Aliases: Dev Env ---
alias serve='python3 -m http.server'
alias reload='source ~/.zshrc'
alias editz='nano ~/.zshrc'
alias mkd='mkdir -p'

# --- Aliases: Docker ---
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dstart='docker start'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dexec='docker exec -it'

# --- Aliases: Cleanup ---
alias cl='clear && echo "📦 Clean and ready!"'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanupnode='rm -rf node_modules && rm package-lock.json && npm install'
alias cleanupgit='git clean -fd && git reset --hard'

# --- Aliases: Networking ---
alias pingg='ping google.com'
alias speed='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias httpserver='python3 -m http.server 8000'

# --- Aliases: Productivity ---
alias now='date +"%T"'
alias today='date +"%A, %B %d, %Y"'
alias wttr='curl wttr.in'
alias cal='cal -3'
alias stopwatch='time read -p "Press enter to stop..."'

# --- Aliases: NPM / Node ---
alias ni='npm install'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'

# --- Aliases: Yarn ---
alias yi='yarn install'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'

# --- Aliases: Java ---
alias javacompile='javac *.java'
alias javarun='java Main'

# --- Reload Shell ---
alias restart-shell='exec $SHELL -l'

# --- fzf Config ---
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- Homebrew ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- PATH ---
export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:/opt/homebrew/bin:$PATH"

# --- bun ---
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- zoxide ---
[[ $(command -v zoxide) ]] && eval "$(zoxide init zsh)"

# --- Local aliases (not tracked in git) ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
