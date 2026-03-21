# NSX Midnight Rice 🟣

Ein Arch Linux Rice inspiriert vom Honda NSX (NA1) 

---

Die Entwicklung des Sportwagens folgte fünf Prinzipien:

    Das Aluminium-Monocoque: Ein radikaler Verzicht auf Stahl, um ein Chassis zu schaffen, das frei von unnötigem Ballast ist und maximale strukturelle Steifigkeit bietet.

    Human-Machine Interface (HMI): Ein Cockpit, das den Fahrer als zentrales Rechenwerk begreift. Jedes Bedienelement ist ohne Umwege und blind erreichbar.

    311° Rundumsicht: Inspiriert von der F-16 „Fighting Falcon“ Bubble-Canopy. Das Ziel ist eine barrierefreie Wahrnehmung der Umgebung, bei der die Maschine visuell verschwindet.

    VTEC (Variable Valve Timing): Eine technologische Lösung für das „Zwei-Seelen“-Problem – hocheffizient und dezent im Leerlauf, aber sofortige Kraftentfaltung bei hoher Last.

    Senna-Abstimmung: Die radikale Überprüfung jedes einzelnen Wertes auf dem Prüfstand von Suzuka, um sicherzustellen, dass keine einzige Werkseinstellung dem Zufall überlassen bleibt.

NSX Midnight wurde als direkter digitaler Zwilling dieser Philosophie entwickelt. Jede Komponente dieses Arch Linux Setups ist so kalibriert, dass sie diesen mechanischen Idealen in der digitalen Infrastruktur entspricht.

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

