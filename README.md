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
- Hyprland installed
- Git

### Setup

I currently don't have an install script, but you can manually copy the files to your home directory or use a symlink approach.

```sh
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles

## Structure

- `hypr/` — Hyprland configs
- `waybar/` — Waybar status bar configs
- `scripts/` — Custom scripts
- `nvim/` — Neovim configs
- `zsh/`, `bash/` — Shell configs
- `gtk/` — GTK themes and settings
```
