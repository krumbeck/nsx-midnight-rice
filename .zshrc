# =============================================================================
# NSX Rice — .zshrc
# Shell: Zsh
# Palette: Sanzo Wada — 7月の配色 / Tech Geisha
# Philosophie: Schnell laden, kein Bloat, alles erreichbar
#
# Struktur:
#   1. Performance — schneller Start
#   2. Zinit — Plugin Manager
#   3. Plugins
#   4. Optionen
#   5. History
#   6. Completion
#   7. Aliase — Fingerkuppen-Bedienung
#   8. Funktionen
#   9. Umgebungsvariablen
#  10. Starship Prompt
# =============================================================================


# -----------------------------------------------------------------------------
# 1. PERFORMANCE — Profiling (auskommentiert, nur bei Bedarf)
# Zum Debuggen: zsh-Startzeit messen
# Aktivieren: die zwei Zeilen auskommentieren + "zprof" am Ende
# -----------------------------------------------------------------------------

# zmodload zsh/zprof


# -----------------------------------------------------------------------------
# 2. ZINIT — Plugin Manager
# Leichtgewichtig, lazy-loading fähig — kein Oh-My-Zsh Overhead
# Installation: sh -c "$(curl -fsSL https://git.io/zinit-install)"
# -----------------------------------------------------------------------------

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Zinit installieren falls nicht vorhanden
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"


# -----------------------------------------------------------------------------
# 3. PLUGINS — nur was täglich gebraucht wird
# -----------------------------------------------------------------------------

# Syntax Highlighting — Befehle färben sich beim Tippen
# Grün = valider Befehl, Rot = unbekannt
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions — schlägt den letzten passenden Befehl vor (Tab oder →)
zinit light zsh-users/zsh-autosuggestions

# Bessere Completions
zinit light zsh-users/zsh-completions

# Fuzzy History — Strg+R mit Preview
zinit light Aloxaf/fzf-tab

# Nützliche Aliase (ls → eza, cat → bat etc.) — nur laden, wir überschreiben unten
zinit snippet OMZP::git


# -----------------------------------------------------------------------------
# 4. OPTIONEN — Zsh-Verhalten
# -----------------------------------------------------------------------------

# Verzeichnis wechseln ohne cd
setopt AUTO_CD

# Tippfehler in Verzeichnisnamen korrigieren
setopt CDABLE_VARS
setopt CORRECT

# Keine doppelten Einträge in der History
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Globbing erweitern
setopt EXTENDED_GLOB
setopt GLOB_DOTS           # . Dateien in Globbing einschließen

# Kein Beep
unsetopt BEEP

# Hintergrundprozesse nicht melden wenn Shell beendet
setopt NO_HUP

# Pipes nicht schließen wenn ein Befehl fehlschlägt
setopt PIPE_FAIL


# -----------------------------------------------------------------------------
# 5. HISTORY — der Fahrtenschreiber
# -----------------------------------------------------------------------------

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# History zwischen Sessions teilen
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Zeitstempel in History speichern
setopt EXTENDED_HISTORY

# Leerzeichen-präfixierte Befehle nicht speichern (für sensitive Infos)
setopt HIST_IGNORE_SPACE


# -----------------------------------------------------------------------------
# 6. COMPLETION — intelligente Vervollständigung
# -----------------------------------------------------------------------------

autoload -Uz compinit

# Completion-Cache nur täglich neu laden (Performance)
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion-Stil
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose true

# Gruppierte Completions
zstyle ':completion:*:*:*:*:descriptions' format '%F{#7B52AB}── %d ──%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{#FF8C00}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format '%F{#6e6a86}%d%f'
zstyle ':completion:*:warnings' format '%F{#FF4444}Keine Treffer: %d%f'

# fzf-tab Styling — konsistent mit NSX-Palette
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:*' fzf-flags --color=bg+:#191724,fg:#E0DEF4,hl:#FF00FF,hl+:#FF00FF,border:#7B52AB


# -----------------------------------------------------------------------------
# 7. ALIASE — Fingerkuppen-Bedienung
# Moderne Rust-Tools wo verfügbar
# -----------------------------------------------------------------------------

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias rice='cd ~/Projects/nsx-midnight-rice'  # Direktzugang zum Rice

# --- ls → eza (modernes ls mit Icons) ---
# Fallback auf ls wenn eza nicht installiert
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza --icons --group-directories-first -l --git'
    alias la='eza --icons --group-directories-first -la --git'
    alias lt='eza --icons --tree --level=2'
    alias lta='eza --icons --tree --level=3 -a'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
fi

# --- cat → bat (Syntax Highlighting) ---
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
    alias catn='bat'                  # Mit Zeilennummern und Header
else
    alias cat='cat'
fi

# --- grep → ripgrep ---
if command -v rg &>/dev/null; then
    alias grep='rg'
fi

# --- find → fd ---
if command -v fd &>/dev/null; then
    alias find='fd'
fi

# --- Git Shortcuts ---
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'

# --- System ---
alias update='sudo pacman -Syu'                          # Arch Update
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias orphans='sudo pacman -Rns $(pacman -Qtdq)'        # Verwaiste Pakete entfernen

# --- Hyprland / Rice ---
alias hypr='nvim ~/.config/hypr/hyprland.conf'
alias kittyconf='nvim ~/.config/kitty/kitty.conf'
alias wayconf='nvim ~/.config/waybar/config.jsonc'
alias waystyle='nvim ~/.config/waybar/style.css'
alias starconf='nvim ~/starship.toml'
alias zshconf='nvim ~/.zshrc'
alias reload='source ~/.zshrc && echo "  .zshrc neu geladen"'

# --- Nützliches ---
alias mkdir='mkdir -pv'             # Elternverzeichnisse automatisch erstellen
alias cp='cp -iv'                   # Interaktiv + verbose
alias mv='mv -iv'
alias rm='rm -iv'                   # Sicher löschen (fragt nach)
alias df='df -h'                    # Lesbare Größen
alias du='du -sh'
alias free='free -h'
alias ports='ss -tlnp'              # Offene Ports anzeigen
alias ip='ip -c'                    # Farbige IP-Ausgabe
alias ping='ping -c 5'
alias history='history 1'           # Vollständige History
alias week='date +%V'               # Aktuelle Woche

# --- Spaß ---
alias please='sudo'
alias fucking='sudo'


# -----------------------------------------------------------------------------
# 8. FUNKTIONEN — kleine Helfer
# -----------------------------------------------------------------------------

# mkcd — Verzeichnis erstellen und direkt wechseln
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# extract — jedes Archiv entpacken
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"   ;;
            *.tar.gz)   tar xzf "$1"   ;;
            *.tar.xz)   tar xJf "$1"   ;;
            *.tar.zst)  tar --zstd -xf "$1" ;;
            *.bz2)      bunzip2 "$1"   ;;
            *.gz)       gunzip "$1"    ;;
            *.tar)      tar xf "$1"    ;;
            *.tbz2)     tar xjf "$1"   ;;
            *.tgz)      tar xzf "$1"   ;;
            *.zip)      unzip "$1"     ;;
            *.Z)        uncompress "$1" ;;
            *.7z)       7z x "$1"      ;;
            *.zst)      unzstd "$1"    ;;
            *)          echo "  Unbekanntes Format: '$1'" ;;
        esac
    else
        echo "  '$1' ist keine gültige Datei"
    fi
}

# gi — .gitignore Template holen (via gitignore.io)
gi() {
    curl -sL "https://www.toptal.com/developers/gitignore/api/$1"
}

# up — n Verzeichnisse nach oben
up() {
    local d=""
    local limit="${1:-1}"
    for ((i=1; i<=limit; i++)); do
        d="../$d"
    done
    cd "$d" || return
}

# rice-push — schneller Commit + Push für Rice-Änderungen
rice-push() {
    local msg="${1:-update: Rice-Konfiguration angepasst}"
    cd ~/Projects/nsx-midnight-rice
    git add .
    git commit -m "$msg"
    git push
    echo "  Rice gepusht: $msg"
}

# sysinfo — schneller Systemüberblick
sysinfo() {
    echo ""
    echo "  $(uname -srm)"
    echo "  Uptime: $(uptime -p)"
    echo "  Shell: $SHELL"
    echo "  Terminal: $TERM"
    echo ""
}


# -----------------------------------------------------------------------------
# 9. UMGEBUNGSVARIABLEN
# -----------------------------------------------------------------------------

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# less — bessere Darstellung
export LESS="-R --use-color"
export LESS_TERMCAP_mb=$'\e[1;35m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_so=$'\e[1;33m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'

# fzf — Fuzzy Finder mit Sanzo Wada Palette — 7月の配色
# bg:      花色  — Violet Blue Background
# hl:      飴色  — Orange Rufous Highlight
# prompt:  桔梗色 — Blue Violet
# border:  桔梗色
export FZF_DEFAULT_OPTS='
    --color=bg+:#2d2d5e,bg:#1e1f3d,spinner:#c97a2a,hl:#c97a2a
    --color=fg:#c4b8bc,header:#5c3d9e,info:#b57fb8,pointer:#c97a2a
    --color=marker:#c97a2a,fg+:#c4b8bc,prompt:#5c3d9e,hl+:#c97a2a
    --color=border:#5c3d9e
    --border=rounded
    --prompt='❯ '
    --pointer='▸'
    --marker='✓'
    --height=40%
    --layout=reverse
'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"    # Rust/Cargo

# Wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland


# -----------------------------------------------------------------------------
# 10. STARSHIP PROMPT
# Muss am Ende stehen
# -----------------------------------------------------------------------------

# History-Verzeichnis sicherstellen
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

# Starship initialisieren
eval "$(starship init zsh)"


# =============================================================================
# Ende — NSX Rice / .zshrc — 7月の配色
# =============================================================================
