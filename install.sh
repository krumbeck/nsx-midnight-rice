#!/usr/bin/env bash
# =============================================================================
# NSX Midnight Rice — install.sh
# Installations-Script für Arch Linux
#
# Verwendung:
#   git clone https://github.com/krumbeck/nsx-midnight-rice.git
#   cd nsx-midnight-rice
#   chmod +x install.sh
#   ./install.sh
#
# Was dieses Script macht:
#   1. Abhängigkeiten prüfen & installieren (paru als AUR-Helper)
#   2. Config-Verzeichnisse anlegen
#   3. Dotfiles symlinken (nicht kopieren — Änderungen wirken sofort)
#   4. Zsh als Standard-Shell setzen
#   5. Starship initialisieren
#
# Philosophie: Aluminium-Monocoque — kein Bloat, jeder Schritt ist bewusst
# =============================================================================

set -euo pipefail  # Bei Fehler sofort abbrechen

# -----------------------------------------------------------------------------
# FARBEN — auch das Script nutzt die NSX-Palette
# -----------------------------------------------------------------------------

PURPLE='\033[0;35m'
MAGENTA='\033[1;35m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
DIM='\033[0;90m'
BOLD='\033[1m'
RESET='\033[0m'

# -----------------------------------------------------------------------------
# HILFSFUNKTIONEN
# -----------------------------------------------------------------------------

# Header ausgeben
header() {
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${MAGENTA}  NSX Midnight Rice — Installer${RESET}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

# Schritt ausgeben
step() {
    echo -e "${PURPLE}❯${RESET} ${BOLD}$1${RESET}"
}

# Erfolg
ok() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

# Info
info() {
    echo -e "  ${DIM}→ $1${RESET}"
}

# Warnung
warn() {
    echo -e "  ${ORANGE}⚠${RESET} $1"
}

# Fehler
error() {
    echo -e "  ${RED}✗${RESET} $1"
    exit 1
}

# Bestätigung abfragen
confirm() {
    echo -e "  ${ORANGE}?${RESET} $1 ${DIM}[j/N]${RESET} "
    read -r response
    [[ "$response" =~ ^[jJyY]$ ]]
}


# -----------------------------------------------------------------------------
# PRÜFUNGEN
# -----------------------------------------------------------------------------

check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        error "Dieses Script ist für Arch Linux. Gefunden: $(uname -s)"
    fi
    ok "Arch Linux erkannt"
}

check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        error "Nicht als Root ausführen. Sudo wird bei Bedarf abgefragt."
    fi
    ok "Kein Root-User"
}

check_wayland() {
    if [[ -z "${WAYLAND_DISPLAY:-}" ]] && [[ -z "${XDG_SESSION_TYPE:-}" ]]; then
        warn "Wayland nicht aktiv — Config wird trotzdem installiert"
    else
        ok "Wayland-Session erkannt"
    fi
}

# Wo liegt das Script / Repo?
RICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# =============================================================================
# HAUPTPROGRAMM
# =============================================================================

header

echo -e "${DIM}Repo-Pfad: ${RICE_DIR}${RESET}"
echo ""

# Grundprüfungen
step "System prüfen"
check_arch
check_not_root
check_wayland
echo ""


# -----------------------------------------------------------------------------
# SCHRITT 1 — AUR-Helper (paru)
# -----------------------------------------------------------------------------

step "AUR-Helper prüfen"

if command -v paru &>/dev/null; then
    ok "paru bereits installiert"
elif command -v yay &>/dev/null; then
    ok "yay gefunden — wird als AUR-Helper verwendet"
    AUR_HELPER="yay"
else
    info "paru wird installiert..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru && makepkg -si --noconfirm
    cd "$RICE_DIR"
    ok "paru installiert"
fi

AUR_HELPER="${AUR_HELPER:-paru}"
echo ""


# -----------------------------------------------------------------------------
# SCHRITT 2 — Abhängigkeiten installieren
# -----------------------------------------------------------------------------

step "Abhängigkeiten installieren"
echo ""

# Pakete definieren
PACKAGES=(
    # Compositor & Shell
    "hyprland"
    "hyprpaper"
    "xdg-desktop-portal-hyprland"

    # Terminal
    "kitty"

    # Shell
    "zsh"
    "starship"

    # Status Bar
    "waybar"

    # Notifications
    "swaync"

    # Launcher
    "rofi-wayland"

    # Wallpaper
    "swww"

    # System Monitor
    "btop"

    # Fonts — Nerd Font für Icons im Prompt und Waybar
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    "noto-fonts"
    "noto-fonts-emoji"

    # Icons
    "papirus-icon-theme"

    # Moderne CLI-Tools (Rust-basiert)
    "eza"                   # ls Ersatz
    "bat"                   # cat Ersatz
    "fd"                    # find Ersatz
    "ripgrep"               # grep Ersatz
    "fzf"                   # Fuzzy Finder

    # Clipboard
    "wl-clipboard"
    "cliphist"

    # Screenshot
    "grimblast"

    # Audio
    "pipewire"
    "pipewire-pulse"
    "wireplumber"
    "pavucontrol"

    # Netzwerk
    "networkmanager"
    "nm-connection-editor"

    # Polkit
    "polkit-gnome"

    # Helfer
    "brightnessctl"
    "playerctl"
    "stow"                  # Symlink-Manager
)

echo -e "  ${DIM}Folgende Pakete werden installiert:${RESET}"
echo ""

for pkg in "${PACKAGES[@]}"; do
    echo -e "    ${DIM}·${RESET} $pkg"
done

echo ""

if confirm "Alle Pakete installieren?"; then
    $AUR_HELPER -S --needed --noconfirm "${PACKAGES[@]}"
    ok "Alle Pakete installiert"
else
    warn "Paketinstallation übersprungen"
fi

echo ""


# -----------------------------------------------------------------------------
# SCHRITT 3 — Config-Verzeichnisse anlegen
# -----------------------------------------------------------------------------

step "Verzeichnisse anlegen"

DIRS=(
    "$HOME/.config/hypr"
    "$HOME/.config/kitty"
    "$HOME/.config/waybar"
    "$HOME/.config/rofi"
    "$HOME/.config/swaync"
    "$HOME/.config/btop/themes"
    "$HOME/.local/share/zinit"
    "$HOME/.local/state/zsh"
    "$HOME/Pictures/wallpapers"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    ok "$dir"
done

echo ""


# -----------------------------------------------------------------------------
# SCHRITT 4 — Dotfiles symlinken
# Symlinks statt Kopieren:
# Änderungen im Repo wirken sofort, git pull aktualisiert alles
# -----------------------------------------------------------------------------

step "Dotfiles symlinken"
echo ""

# Funktion: sicher symlinken (Backup wenn Datei bereits existiert)
safe_link() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        # Bereits ein Symlink — überschreiben
        ln -sf "$src" "$dst"
        ok "Aktualisiert: $dst"
    elif [[ -f "$dst" ]] || [[ -d "$dst" ]]; then
        # Existierende Datei — Backup erstellen
        mv "$dst" "${dst}.backup-$(date +%Y%m%d-%H%M%S)"
        warn "Backup erstellt: ${dst}.backup"
        ln -s "$src" "$dst"
        ok "Verlinkt: $dst"
    else
        # Neu anlegen
        ln -s "$src" "$dst"
        ok "Verlinkt: $dst"
    fi
}

# Config-Files verlinken
safe_link "$RICE_DIR/.config/hypr/hyprland.conf"      "$HOME/.config/hypr/hyprland.conf"
safe_link "$RICE_DIR/.config/kitty/kitty.conf"         "$HOME/.config/kitty/kitty.conf"
safe_link "$RICE_DIR/.config/waybar/config.jsonc"      "$HOME/.config/waybar/config.jsonc"
safe_link "$RICE_DIR/.config/waybar/style.css"         "$HOME/.config/waybar/style.css"
safe_link "$RICE_DIR/.config/rofi/config.rasi"         "$HOME/.config/rofi/config.rasi"
safe_link "$RICE_DIR/.config/swaync/config.json"       "$HOME/.config/swaync/config.json"
safe_link "$RICE_DIR/.config/swaync/style.css"         "$HOME/.config/swaync/style.css"
safe_link "$RICE_DIR/.config/btop/btop.conf"           "$HOME/.config/btop/btop.conf"
safe_link "$RICE_DIR/.config/btop/themes/nsx-midnight.theme" \
          "$HOME/.config/btop/themes/nsx-midnight.theme"

# Home-Dotfiles
safe_link "$RICE_DIR/.zshrc"          "$HOME/.zshrc"
safe_link "$RICE_DIR/starship.toml"   "$HOME/.config/starship.toml"

echo ""


# -----------------------------------------------------------------------------
# SCHRITT 5 — Zsh als Standard-Shell
# -----------------------------------------------------------------------------

step "Zsh als Standard-Shell setzen"

if [[ "$SHELL" == "$(which zsh)" ]]; then
    ok "Zsh bereits Standard-Shell"
else
    if confirm "Zsh als Standard-Shell setzen?"; then
        chsh -s "$(which zsh)"
        ok "Zsh gesetzt — wirkt ab dem nächsten Login"
    else
        warn "Shell nicht geändert — bleibt: $SHELL"
    fi
fi

echo ""


# -----------------------------------------------------------------------------
# SCHRITT 6 — Zinit installieren (Zsh Plugin Manager)
# -----------------------------------------------------------------------------

step "Zinit prüfen"

ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

if [[ -d "$ZINIT_HOME" ]]; then
    ok "Zinit bereits installiert"
else
    info "Zinit wird installiert..."
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    ok "Zinit installiert"
fi

echo ""


# -----------------------------------------------------------------------------
# SCHRITT 7 — Wallpaper Hinweis
# -----------------------------------------------------------------------------

step "Wallpaper"

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

if [[ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]]; then
    warn "Keine Wallpapers in $WALLPAPER_DIR gefunden"
    echo ""
    echo -e "  ${DIM}Empfehlung für einen Tokyo-Nacht-Wallpaper:${RESET}"
    echo -e "  ${DIM}→ https://unsplash.com/s/photos/tokyo-night${RESET}"
    echo -e "  ${DIM}→ https://wallhaven.cc/search?q=tokyo+night&categories=100&purity=100${RESET}"
    echo ""
    echo -e "  ${DIM}Datei als gespeichert:${RESET}"
    echo -e "  ${DIM}~/Pictures/wallpapers/tokyo-night.jpg${RESET}"
    echo ""
    echo -e "  ${DIM}Dann in hyprland.conf den Pfad prüfen:${RESET}"
    echo -e "  ${DIM}exec-once = swww img ~/Pictures/wallpapers/tokyo-night.jpg${RESET}"
else
    ok "Wallpapers gefunden in $WALLPAPER_DIR"
fi

echo ""


# =============================================================================
# ABSCHLUSS
# =============================================================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${GREEN}  ✓ Installation abgeschlossen${RESET}"
echo ""
echo -e "${DIM}  Nächste Schritte:${RESET}"
echo ""
echo -e "  ${PURPLE}1.${RESET} Neu einloggen damit Zsh als Shell aktiv wird"
echo -e "  ${PURPLE}2.${RESET} Wallpaper in ~/Pictures/wallpapers/ ablegen"
echo -e "  ${PURPLE}3.${RESET} Monitor in hyprland.conf anpassen:"
echo -e "     ${DIM}monitor = eDP-1, 1920x1080@60, 0x0, 1${RESET}"
echo -e "  ${PURPLE}4.${RESET} Hyprland starten:"
echo -e "     ${DIM}Hyprland${RESET}"
echo ""
echo -e "${DIM}  Bei Problemen: github.com/krumbeck/nsx-midnight-rice${RESET}"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${MAGENTA}  「電子詩」— Elektronische Poesie.${RESET}"
echo -e "${DIM}  Flüssig, rhythmisch, eins mit der Maschine.${RESET}"
echo ""

# =============================================================================
# Ende — NSX Midnight Rice / install.sh
# =============================================================================
