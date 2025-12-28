#!/bin/sh
# Setup dependencies on Arch Linux.

set -euo pipefail

pacman -S acpica brightnessctl biome blueman bluez clang curl dmidecode direnv \
  dolphin efibootmgr efivar fd firefox fish fzf fwupd git github-cli keepassxc \
  kitty go hyprland jq less lua luarocks ly lz4 mako man-db mise most \
  noto-fonts-cjk npm nvim perl prettier python python-pip rofi rust-analyzer \
  starship stylua tokei tmux tree ttf-jetbrains-mono-nerd uv vlc \
  vlc-plugins-all waybar wget wl-clipboard zoxide

cargo install --locked tree-sitter-cli
