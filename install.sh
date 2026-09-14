#!/usr/bin/env bash
# Apply the Rose Pine GNOME/Ubuntu setup. Safe to re-run.
#
#   ./install.sh                    full setup
#   ./install.sh --no-shell-theme   skip the GNOME Shell part (see README)
#   ./install.sh --dry-run          print what would happen, change nothing
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME=Rosepine-Dark
DRY=0
SHELL_THEME=1

for a in "$@"; do
  case "$a" in
    --dry-run)         DRY=1 ;;
    --no-shell-theme)  SHELL_THEME=0 ;;
    -h|--help)         sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "unknown option: $a" >&2; exit 1 ;;
  esac
done

run() { if [ "$DRY" = 1 ]; then echo "  [dry-run] $*"; else "$@"; fi; }
say() { printf '\n\033[1m%s\033[0m\n' "$*"; }

# ---------------------------------------------------------------- sanity
if [ "${XDG_CURRENT_DESKTOP:-}" != "" ] && [[ "${XDG_CURRENT_DESKTOP}" != *GNOME* ]]; then
  echo "warning: XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP}, this is built for GNOME" >&2
fi

# ---------------------------------------------------------------- gtk theme
say "1/4  GTK theme -> ~/.themes/$THEME"
run mkdir -p "$HOME/.themes"
if [ -d "$HOME/.themes/$THEME" ] && [ "$DRY" = 0 ]; then
  BAK="$HOME/.themes/$THEME-replaced-$(date +%Y%m%d-%H%M%S).tar.gz"
  tar czf "$BAK" -C "$HOME/.themes" "$THEME"
  echo "  backed up existing theme -> $BAK"
  rm -rf "${HOME:?}/.themes/${THEME:?}"
fi
run cp -a "$REPO/themes/$THEME" "$HOME/.themes/"

run gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
run gsettings set org.gnome.desktop.interface color-scheme prefer-dark
echo "  gtk-theme=$THEME  color-scheme=prefer-dark"

# ---------------------------------------------------------------- rofi
say "2/4  rofi theme -> ~/.config/rofi/themes/rose-pine.rasi"
run mkdir -p "$HOME/.config/rofi/themes"
run cp -a "$REPO/rofi/rose-pine.rasi" "$HOME/.config/rofi/themes/"
echo "  its 'background: #191724' must match the GTK window background"

# ---------------------------------------------------------------- shell theme
if [ "$SHELL_THEME" = 1 ]; then
  say "3/4  GNOME Shell theme (User Themes extension)"
  UUID=user-theme@gnome-shell-extensions.gcampax.github.com

  if [ ! -d "/usr/share/gnome-shell/extensions/$UUID" ]; then
    echo "  User Themes is not installed. Run:"
    echo "      sudo apt install gnome-shell-extensions"
    echo "  then re-run this script."
  else
    run gsettings set org.gnome.shell.extensions.user-theme name "$THEME"
    # gnome-extensions enable fails if the running shell has not rescanned the
    # extensions dir yet, so write the key directly -- it applies on next login.
    if [ "$DRY" = 0 ]; then
      python3 - "$UUID" <<'PY'
import ast, subprocess, sys
uuid = sys.argv[1]
cur = subprocess.check_output(
    ["gsettings", "get", "org.gnome.shell", "enabled-extensions"], text=True).strip()
lst = ast.literal_eval(cur)
if uuid in lst:
    print("  already in enabled-extensions")
else:
    lst.append(uuid)
    subprocess.run(["gsettings", "set", "org.gnome.shell", "enabled-extensions",
                    "[" + ", ".join("'%s'" % e for e in lst) + "]"], check=True)
    print("  added to enabled-extensions")
PY
    else
      echo "  [dry-run] add $UUID to enabled-extensions"
    fi
    echo "  NOTE: this theme paints the top bar rgba(25,23,36,0.85)."
    echo "        If you keep a transparent panel, see README > Transparent top bar."
  fi
else
  say "3/4  GNOME Shell theme -- skipped (--no-shell-theme)"
fi

# ---------------------------------------------------------------- reload
say "4/4  reload"
if [ "$DRY" = 0 ]; then
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita
  sleep 2
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
  echo "  GTK apps reloaded"
else
  echo "  [dry-run] toggle gtk-theme through Adwaita to force a reload"
fi

cat <<EOF

Done.

GTK apps pick this up immediately. GNOME Shell does not -- it scans extensions
only at startup, and on Wayland you cannot restart it in place. Log out and back
in (staying on Wayland is fine) for the shell theme to load.

Not handled here, set them yourself if you want them:
  icons   gsettings set org.gnome.desktop.interface icon-theme '<name>'
  cursor  gsettings set org.gnome.desktop.interface cursor-theme '<name>'
EOF
