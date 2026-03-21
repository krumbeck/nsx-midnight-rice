# NSX Midnight Rice 🟣

> *"In dem Moment, in dem du dich in den NSX setzt, verschwindet die Angst."*

Ein Arch Linux Rice inspiriert vom Honda NSX (NA1) in **Midnight Purple Pearl** —
gebaut nach derselben Philosophie: kein Bloat, kein Kompromiss, maximale Präzision.

---

## Philosophie

Der Honda NSX war keine Antwort auf die Frage *"Wie bauen wir einen schnellen Wagen?"*
Er war die Antwort auf *"Wie bauen wir den perfekten Wagen?"*

Dieses Rice folgt derselben Logik:

| NSX-Prinzip | Rice-Entsprechung |
|---|---|
| Aluminium-Monocoque (Null Bloat) | Arch Linux — nur was gebraucht wird |
| Human-Machine Interface | Keybinding-first, kein GUI-Overhead |
| 311° Rundumsicht (F-16 Kanzel) | Blur + Transparenz — die Stadt atmet durch |
| VTEC — zwei Seelen | Idle: dezent & dunkel / Load: scharf & kontrastreich |
| Senna-Abstimmung | Jeder Wert ist bewusst gesetzt, nichts ist Default |

---

## Ästhetische DNA

```
Background  #0B0811   Midnight — der Schatten des Lacks
Purple      #7B52AB   Midnight Purple Pearl (PB-73P)
Magenta     #FF00FF   VTEC-Kick / Neon-Reflexion
Orange      #FF8C00   Tokyo Tower / Tachometer-Nadel
Text        #E0DEF4   Cockpit-Display, klinisch & klar
```

Inspirationsquellen: Shuto Expressway bei Nacht · Mid Night Club · JDM-Ästhetik der 90er ·
F-16 Fighting Falcon Cockpit · Konbini-Neon · Midnight Purple II Flip-Flop-Lack

---

## Stack

| Komponente | Tool | Begründung |
|---|---|---|
| Compositor | Hyprland | Wayland-native, GPU-beschleunigt |
| Terminal | Kitty | GPU-rendered, scriptbar |
| Shell | Zsh + Starship | Minimal prompt, Git-aware |
| Status Bar | Waybar | Floating Islands, CSS-stylebar |
| Launcher | Rofi-Wayland | Schnell, tastaturgesteuert |
| Notifications | SwayNC | HUD-style, kein Noise |
| Wallpaper | SWWW | Smooth transitions |
| System Monitor | Btop | Terminal-native |

---

## Struktur

```
nsx-midnight-rice/
├── .config/
│   ├── hypr/
│   │   ├── hyprland.conf       # Compositor, Keybindings, Animationen
│   │   └── hyprpaper.conf      # Wallpaper-Config
│   ├── kitty/
│   │   └── kitty.conf          # Terminal — Glass Cockpit
│   ├── waybar/
│   │   ├── config.jsonc        # Bar-Layout (Floating Islands)
│   │   └── style.css           # NSX-Farbpalette in CSS
│   ├── rofi/
│   │   └── config.rasi         # Launcher
│   └── swaync/
│       ├── config.json         # Notification Daemon
│       └── style.css
├── .zshrc                      # Shell-Konfiguration
├── starship.toml               # Prompt — Purple idle, Magenta on Git/Error
├── wallpapers/                 # Tokyo bei Nacht (Referenzen)
└── README.md                   # Dieses Dokument
```

---

## Installation (auf dem Ziel-System)

### 1. Abhängigkeiten installieren

```bash
paru -S hyprland kitty zsh starship waybar rofi-wayland swaync swww btop \
        nerd-fonts-jetbrains-mono ttf-font-awesome
```

### 2. Repo klonen

```bash
git clone https://github.com/krumbeck/nsx-midnight-rice.git ~/Projects/nsx-midnight-rice
```

### 3. Configs symlinken (mit GNU Stow)

```bash
cd ~/Projects/nsx-midnight-rice
stow .
```

### 4. Hyprland starten

```bash
Hyprland
```

---

## Entwicklungsstatus

- [ ] `hyprland.conf` — Grundkonfiguration
- [ ] `kitty.conf` — Glass Cockpit Terminal
- [ ] `waybar/` — Floating Island Bar
- [ ] `starship.toml` — Prompt
- [ ] `rofi/` — Launcher
- [ ] `swaync/` — Notifications
- [ ] `.zshrc` — Shell
- [ ] Wallpaper-Auswahl finalisieren

---

## Referenzen & Inspiration

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Dokumentation](https://github.com/Alexays/Waybar/wiki)
- [Catppuccin](https://github.com/catppuccin/catppuccin) — Ausgangspunkt für Farbsystem
- [r/unixporn](https://reddit.com/r/unixporn) — Community & Inspiration
- Honda NSX NA1 (1990–2005) — die eigentliche Blaupause

---

*Gebaut auf einem Acer Aspire A314-22 · Pop!_OS 24.04 · für ein ThinkPad bestimmt*
*"Elektronische Poesie. Man fährt nicht nur ein Auto — man steuert einen Pfeil durch das Herz einer digitalen Zivilisation."*
