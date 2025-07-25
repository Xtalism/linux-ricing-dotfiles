# Hyprland Dotfiles

This repository contains my personal dotfiles for a Linux system running [Hyprland](https://github.com/hyprwm/Hyprland), a dynamic tiling Wayland compositor. The wallpaper was created by [jrmnt](https://wallhaven.cc/user/jrmnt) in the [Wallhaven](https://wallhaven.cc/) platform.

![Overview](assets/screenshots/main.png)
![Neovim](assets/screenshots/nvim.png)
![Neovim-Config](assets/screenshots/nvim-config.png)
![Rofi](assets/screenshots/rofi.png)
![Thunar](assets/screenshots/thunar.png)

## Features

- Hyprland configuration
- Wayland environment setup
- Theming (GTK, icons, cursors)
- Terminal and shell configs (e.g., zsh, bash)
- Editor configs (e.g., Neovim)
- Scripts and utilities

## Installation

**Warning:** These dotfiles are tailored for my workflow and may overwrite your existing configs.

### Prerequisites

- Linux (tested on Arch, Fedora, Ubuntu)
- Hyprland
- Wayland
- Rofi
- GTK
- Waybar
- Git

#### GTK Themes

In order to use the GTK themes, you need to install `dconf-editor`:

```sh
sudo apt install dconf-editor
```

Once installed, go to your `~/.themes`, copy the GTK themes from this repository to your `~/.themes` directory.

```sh
mkdir -p ~/.themes
cd ~/.themes
mv ~linux-ricing-dotfiles/gtk-theme/Rosepine-Dark .
```

Now in your terminal run `dconf-editor`, navigate to `org/gnome/desktop/interface`, and set the `gtk-theme` to `Rosepine-Dark`.

![GTK Theme Setup](assets/screenshots/gtk-theme-setup.png)

### Setup

I currently don't have an install script, but you can manually copy the files to your home directory or use a symlink approach.

```sh
git clone https://github.com/Xtalism/linux-ricing-dotfiles.git
cd dotfiles/
```

## Structure

- `hypr/` — Hyprland configs
- `waybar/` — Waybar status bar configs
- `scripts/` — Custom scripts
- `nvim/` — Neovim configs
- `zsh/`, `bash/` — Shell configs
- `gtk/` — GTK themes and settings

```

```
