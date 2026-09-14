# rosepine-gnome-ubuntu

Rosé Pine theming for **GNOME on Ubuntu (Wayland)** — a recolored `Rosepine-Dark`
GTK theme whose window background matches rofi's, so the drun overlay merges into
the window underneath instead of floating on top of it.

For the Hyprland setup, see [linux-ricing-dotfiles](https://github.com/Xtalism/linux-ricing-dotfiles).

## Install

```sh
git clone https://github.com/Xtalism/rosepine-gnome-ubuntu.git
cd rosepine-gnome-ubuntu
./install.sh
```

`./install.sh --dry-run` prints what it would do first. It backs up any existing
`~/.themes/Rosepine-Dark` to a timestamped tarball before replacing it, and is
safe to re-run.

GTK apps update immediately. **GNOME Shell needs a logout** — it scans extensions
only at startup, and on Wayland you can't restart it in place the way `Alt+F2` →
`r` does on X11.

## What's here

| Path | |
|---|---|
| `themes/Rosepine-Dark/` | the recolored GTK theme, ready to drop in `~/.themes` |
| `rofi/rose-pine.rasi` | rofi theme — its `background:` is what the GTK bg matches |
| `scripts/recolor-rosepine.py` | the recolor itself, to re-derive from a fresh upstream copy |
| `install.sh` | copies files + sets gsettings keys |

## The change

Upstream `Rosepine-Dark` ships a window background of `#111019` — darker than Rosé
Pine's actual base, and darker than rofi's. Re-anchoring it to `#191724` is the
whole point; everything else just snaps onto the standard Rosé Pine ladder.

| Role | Upstream | Here | Rosé Pine |
|---|---|---|---|
| **window / headerbar / sidebar** | `#111019` | **`#191724`** | **base** — 206 uses |
| views / lists / text | `#21202e` | `#21202e` | highlight-low — *unchanged* |
| menus / popovers / OSD | `#232032` | `#26233a` | overlay |
| message dialogs | `#191724` | `#1f1d2e` | surface |
| borders / strokes | `#3c3b47` | `#403d52` | highlight-med |
| tooltips | `#454064` | `#524f67` | highlight-high |

Accents are untouched: `#9ccfd8` foam, `#faf4ed` text, `#b4637a` love, `#ea9d34` gold.

Files modified: `gtk-3.0/gtk.css`, `gtk-3.0/gtk-dark.css`, `gtk-4.0/gtk.css`,
`gtk-4.0/gtk-dark.css`, `gnome-shell/gnome-shell.css`, `cinnamon/cinnamon.css`,
`gtk-2.0/gtkrc`. `prefer-dark` loads the `-dark.css` variants, so both matter.

### Two things that must stay dark

Anything recoloring this theme has to skip these, or contrast breaks:

- **~434 `rgba(25, 23, 36, …)` tokens** — dark ink drawn *on* the light foam/rose
  accent fills. A foreground color, not a background.
- **`#191724` inside `*/assets/*.svg`** — the checkbox/radio/toggle tick, drawn on
  the accent fill. Same role.

`scripts/recolor-rosepine.py` already excludes both.

## Commands

What `install.sh` runs, if you'd rather do it by hand:

```sh
cp -a themes/Rosepine-Dark ~/.themes/
gsettings set org.gnome.desktop.interface gtk-theme Rosepine-Dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

Force GTK apps to re-read the CSS (a theme *change* is the trigger, so bounce it):

```sh
gsettings set org.gnome.desktop.interface gtk-theme Adwaita && sleep 2 && gsettings set org.gnome.desktop.interface gtk-theme Rosepine-Dark
```

GNOME Shell theming, which needs the User Themes extension:

```sh
sudo apt install gnome-shell-extensions
```

```sh
gsettings set org.gnome.shell.extensions.user-theme name Rosepine-Dark
```

`gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com`
errors with *"does not exist"* if the running shell hasn't rescanned the
extensions directory since install. Writing the key directly works instead and
takes effect at next login — `install.sh` does this for you.

## Transparent top bar

The shell theme sets an opaque panel:

```css
#panel {
  background-color: rgba(25, 23, 36, 0.85);
}
```

If you run Blur My Shell or otherwise keep the panel transparent, it will fight
this. Blur My Shell usually wins. To settle it, edit
`themes/Rosepine-Dark/gnome-shell/gnome-shell.css` and set both
`#panel { background-color: transparent; }` and
`#panel .panel-corner { -panel-corner-background-color: transparent; }` — you
keep Rosé Pine menus, overview and OSD popups without touching the bar.

Or skip shell theming entirely with `./install.sh --no-shell-theme`.

## Known limits

- **GTK4 / libadwaita apps ignore `~/.themes`.** Settings and newer GNOME apps
  keep Adwaita's own palette. `GTK_THEME=Rosepine-Dark` forces it per-app but is
  unsupported and recolors inconsistently.
- **`xfwm4/` is dead weight on GNOME.** Those 60 PNGs are XFCE window decorations
  and still carry the upstream `#191724`. Kept for theme completeness.
- **`org.gnome.desktop.wm.preferences theme`** is a legacy Metacity key that
  Mutter ignores. `index.theme` declares `MetacityTheme=Rosepine-Dark`, but
  setting it changes nothing visually.

## Built against

GNOME Shell 46.0 · Ubuntu · Wayland · `XDG_CURRENT_DESKTOP=ubuntu:GNOME`

Icons and cursor aren't included — that setup used `Boston cardboard` icons and
the `Yaru` cursor, neither of which is Rosé Pine.
