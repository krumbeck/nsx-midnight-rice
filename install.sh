#!/usr/bin/env bash
# =============================================================================
# NSX Rice — install.sh
# Palette: Sanzo Wada — 7月の配色 / Tech Geisha
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
#   5. Zinit installieren
#
# Philosophie: kein Bloat, jeder Schritt ist bewusst
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# TERMINAL-FARBEN — 7月の配色 Annäherung
# 花色 → Blau, 桔梗色 → Violett, 飴色 → Orange/Gelb
# -----------------------------------------------------------------------------

VIOLET='\033[0;34m'     # Annäherung 花色 / 桔梗色
LILAC='\033[1;35m'      # Annäherung 鳩羽紫
AMBER='\033[0;33m'      # Annäherung 飴色
GREEN='\033[0;32m'
RED='\033[0;31m'
DIM='\033[0;90m'
BOLD='\033[1m'
RESET='\033[0m'

# -----------------------------------------------------------------------------
# HILFSFUNKTIONEN
# -----------------------------------------------------------------------------

header() {
    echo ""
    echo -e "${VIOLET}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${LILAC}  NSX Rice — Installer${RESET}"
    echo -e "${DIM}  Sanzo Wada · 7月の配色 · Tech Geisha${RESET}"
    echo -e "${VIOLET}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

step() {
    echo -e "${VIOLET}❯${RESET} ${BOLD}$1${RESET}"
}

ok() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

info() {
    echo -e "  ${DIM}→ $1${RESET}"
}

warn() {
    echo -e "  ${AMBER}⚠${RESET} $1"
}

error() {
    echo -e "  ${RED}✗${RESET} $1"
    exit 1
}

confirm() {
    echo -e "  ${AMBER}?${RESET} $1 ${DIM}[j/N]${RESET} "
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

RICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# =============================================================================
# HAUPTPROGRAMM
# =============================================================================

header

echo -e "${DIM}Repo-Pfad: ${RICE_DIR}${RESET}"
echo ""

step "System prüfen"
check_arch
check_not_root
check_wayland
echo ""


# -----------------------------------------------------------------------------
# SCHRITT 1 — AUR-Helper
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
# SCHRITT 2 — Abhängigkeiten
# -----------------------------------------------------------------------------

step "Abhängigkeiten installieren"
echo ""

PACKAGES=(
    # Compositor
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

    # Fonts
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    "noto-fonts"
    "noto-fonts-emoji"

    # Icons
    "papirus-icon-theme"

    # CLI-Tools
    "eza"
    "bat"
    "fd"
    "ripgrep"
    "fzf"

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
    "stow"
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
# SCHRITT 3 — Verzeichnisse
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
# SCHRITT 4 — Symlinks
# -----------------------------------------------------------------------------

step "Dotfiles symlinken"
echo ""

safe_link() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        ln -sf "$src" "$dst"
        ok "Aktualisiert: $dst"
    elif [[ -f "$dst" ]] || [[ -d "$dst" ]]; then
        mv "$dst" "${dst}.backup-$(date +%Y%m%d-%H%M%S)"
        warn "Backup erstellt: ${dst}.backup"
        ln -s "$src" "$dst"
        ok "Verlinkt: $dst"
    else
        ln -s "$src" "$dst"
        ok "Verlinkt: $dst"
    fi
}

safe_link "$RICE_DIR/.config/hypr/hyprland.conf"      "$HOME/.config/hypr/hyprland.conf"
safe_link "$RICE_DIR/.config/kitty/kitty.conf"        "$HOME/.config/kitty/kitty.conf"
safe_link "$RICE_DIR/.config/waybar/config.jsonc"     "$HOME/.config/waybar/config.jsonc"
safe_link "$RICE_DIR/.config/waybar/style.css"        "$HOME/.config/waybar/style.css"
safe_link "$RICE_DIR/.config/rofi/config.rasi"        "$HOME/.config/rofi/config.rasi"
safe_link "$RICE_DIR/.config/swaync/config.json"      "$HOME/.config/swaync/config.json"
safe_link "$RICE_DIR/.config/swaync/style.css"        "$HOME/.config/swaync/style.css"
safe_link "$RICE_DIR/.config/btop/btop.conf"          "$HOME/.config/btop/btop.conf"

# Sanzo Wada Theme — 7月の配色
safe_link "$RICE_DIR/.config/btop/themes/wada-7gatsu.theme" \
          "$HOME/.config/btop/themes/wada-7gatsu.theme"

# Home-Dotfiles
safe_link "$RICE_DIR/.zshrc"         "$HOME/.zshrc"
safe_link "$RICE_DIR/starship.toml"  "$HOME/.config/starship.toml"
safe_link "$RICE_DIR/colors.conf"    "$HOME/.config/colors.conf"

echo ""


# -----------------------------------------------------------------------------
# SCHRITT 5 — Zsh
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
# SCHRITT 6 — Zinit
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
# SCHRITT 7 — Wallpaper
# -----------------------------------------------------------------------------

step "Wallpaper"

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

if [[ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]]; then
    warn "Keine Wallpapers in $WALLPAPER_DIR gefunden"
    echo ""
    echo -e "  ${DIM}Empfohlen: Tokyo bei Nacht — viel Dunkelheit, vereinzelte Lichtquellen.${RESET}"
    echo -e "  ${DIM}→ https://unsplash.com/s/photos/tokyo-night${RESET}"
    echo -e "  ${DIM}→ https://wallhaven.cc/search?q=tokyo+night${RESET}"
    echo ""
    echo -e "  ${DIM}Ablegen unter: ~/Pictures/wallpapers/tokyo-night.jpg${RESET}"
    echo -e "  ${DIM}Pfad in hyprland.conf prüfen:${RESET}"
    echo -e "  ${DIM}exec-once = swww img ~/Pictures/wallpapers/tokyo-night.jpg${RESET}"
else
    ok "Wallpapers gefunden in $WALLPAPER_DIR"
fi

echo ""


# =============================================================================
# ABSCHLUSS
# =============================================================================

echo -e "${VIOLET}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${GREEN}  ✓ Installation abgeschlossen${RESET}"
echo ""
echo -e "${DIM}  Nächste Schritte:${RESET}"
echo ""
echo -e "  ${VIOLET}1.${RESET} Neu einloggen damit Zsh aktiv wird"
echo -e "  ${VIOLET}2.${RESET} Wallpaper in ~/Pictures/wallpapers/ ablegen"
echo -e "  ${VIOLET}3.${RESET} Monitor in hyprland.conf anpassen:"
echo -e "     ${DIM}monitor = eDP-1, 1920x1080@60, 0x0, 1${RESET}"
echo -e "  ${VIOLET}4.${RESET} Hyprland starten:"
echo -e "     ${DIM}Hyprland${RESET}"
echo ""
echo -e "${DIM}  Bei Problemen: github.com/krumbeck/nsx-midnight-rice${RESET}"
echo ""
echo -e "${VIOLET}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${LILAC}  7月の配色 · 花色 · 桔梗色 · 飴色${RESET}"
echo -e "${DIM}  „Du öffnetest das Terminal und dachtest kurz daran, wie viele${RESET}"
echo -e "${DIM}  Entscheidungen in dieser Konfigurationsdatei steckten,${RESET}"
echo -e "${DIM}  die niemand außer dir je sehen würde."${RESET}"
echo ""

# =============================================================================
# Ende — NSX Rice / install.sh — 7月の配色
# =============================================================================
