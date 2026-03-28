# NSX Midnight Rice

> *„btop startet man manchmal nicht um etwas zu prüfen, sondern weil die Farben beruhigen."*

---

Ein Arch Linux Rice auf Basis von Hyprland. Die Farbpalette stammt aus Sanzo Wadas
*Dictionary of Color Combinations*, Kombination 039 — 7月の配色.
Die Ästhetik orientiert sich an der Ingenieursphilosophie des Honda NSX (NA1, 1990):
kein Bloat, die Oberfläche als Konsequenz der Struktur.

---

## Palette

Die Farben kommen aus der japanischen Farbtradition. Auf einem Bildschirm
verhalten sie sich anders als im Druck — das wurde berücksichtigt.

| Japanisch | Englisch | HEX | Rolle |
|---|---|---|---|
| 花色 はないろ | Violet Blue | `#1e1f3d` | Background |
| 二藍 ふたあい | Dark Soft Violet | `#2d2d5e` | Surface |
| 桔梗色 ききょういろ | Blue Violet | `#5c3d9e` | Primary Accent |
| 鳩羽紫 はとばむらさき | Lilac | `#b57fb8` | Secondary Accent |
| 薄色 うすいろ | Grayish Lavender | `#c4b8bc` | Text |
| 飴色 あめいろ | Orange Rufous | `#c97a2a` | Cursor, aktive Elemente |

Das Orange — 飴色 — wird sparsam eingesetzt. Als Fläche würde es die visuelle Balance des Systems sofort verschieben.

---

## Stack

| Komponente | Tool |
|---|---|
| Compositor | Hyprland (Wayland) |
| Terminal | Kitty |
| Shell | Zsh + Starship |
| Status Bar | Waybar (Floating Islands) |
| Launcher | Rofi-Wayland |
| Notifications | SwayNC |
| Wallpaper | SWWW |
| System Monitor | Btop |

---

## Philosophie

Der Honda NSX wurde nicht gebaut um schneller als ein Ferrari zu sein.
Er wurde gebaut um präziser zu sein — zuverlässiger, leichter, fahrbarer.
Das Cockpit war nach dem Vorbild eines F-16-Kampfjets entworfen:
311 Grad Sichtfeld, alle Funktionen mit den Fingerkuppen erreichbar.

Dieses Rice folgt derselben Logik. Nicht mehr Pakete als nötig.
Keybinding-first. Das VTEC-Prinzip gilt auch für die Animationen: im Idle weich und
dezent, unter Last präzise und direkt.

---

## Struktur

```
nsx-midnight-rice/
├── .config/
│   ├── hypr/
│   │   └── hyprland.conf
│   ├── kitty/
│   │   └── kitty.conf
│   ├── waybar/
│   │   ├── config.jsonc
│   │   └── style.css
│   ├── rofi/
│   │   └── config.rasi
│   ├── swaync/
│   │   ├── config.json
│   │   └── style.css
│   └── btop/
│       ├── btop.conf
│       └── themes/
│           └── wada-7gatsu.theme
├── .zshrc
├── starship.toml
├── colors.conf
├── install.sh
└── README.md
```

---

## Installation

### Abhängigkeiten

```bash
paru -S hyprland kitty zsh starship waybar rofi-wayland swaync swww btop \
        ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme \
        eza bat fd ripgrep fzf wl-clipboard cliphist grimblast \
        pipewire pipewire-pulse wireplumber brightnessctl stow
```

### Setup

```bash
git clone https://github.com/krumbeck/nsx-midnight-rice.git
cd nsx-midnight-rice
chmod +x install.sh
./install.sh
```

Das Script symlinkt alle Configs an die richtigen Stellen.
Bestehende Dateien werden mit Zeitstempel gesichert, nicht überschrieben.

### Wallpaper

Ein Wallpaper wird nicht mitgeliefert. Empfohlen wird ein Bild
mit Tokyo bei Nacht — viel Dunkelheit, vereinzelte Lichtquellen.
Ablegen unter `~/Pictures/wallpapers/tokyo-night.jpg`.

---

## Keybindings

| Aktion | Tastenkombination |
|---|---|
| Terminal | `Super + Return` |
| Launcher | `Super + Space` |
| Fenster schließen | `Super + Q` |
| Fullscreen | `Super + Z` |
| Floating toggle | `Super + F` |
| Notification Center | `Super + N` |
| Screenshot (Auswahl) | `Shift + Print` |
| Fokus (Vim-Style) | `Super + H J K L` |
| Workspace wechseln | `Super + 1–9` |

---

## Referenzen

- Sanzo Wada — *Dictionary of Color Combinations Vol. 2*, Seigensha, 青幻舎
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Dokumentation](https://github.com/Alexays/Waybar/wiki)
- Honda NSX NA1 (1990–2005)

---

*„Du öffnetest das Terminal und dachtest kurz daran, wie viele Entscheidungen
in dieser Konfigurationsdatei steckten, die niemand außer dir je sehen würde."*
