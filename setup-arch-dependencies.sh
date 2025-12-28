#!/bin/sh
# Setup dependencies on Arch Linux.

set -euo pipefail

pacman -S acpica brightnessctl bind-tools biome blueman bluez clang curl \
  dmidecode direnv dolphin efibootmgr efivar fd firefox firewalld fish fzf \
  fwupd git github-cli keepassxc kitty go hyprland jq less lua luarocks ly \
  lz4 mako man-db mise most networkmanager network-manager-applet \
  noto-fonts-cjk npm nvim pavucontrol perl pipewire pipewire-alsa \
  pipewire-jack pipewire-pulse prettier python python-pip rofi rust-analyzer \
  snap-pac snapper starship stubby stylua timeshift tmux tokei tree \
  ttf-jetbrains-mono-nerd uv vlc vlc-plugins-all waybar wget wireplumber \
  wl-clipboard zig zoxide

cargo install --locked tree-sitter-cli

# System services
systemctl disable getty@tty1.service            # required for ly
systemctl enable ly@tty1.service                # Display manager
systemctl enable --now firewalld                # Firewall
systemctl enable --now NetworkManager.service   # Network management
systemctl enable --now bluetooth.service        # Bluetooth support (bluez)
systemctl enable --now fwupd.service            # Firmware updates
systemctl enable --now stubby.service           # DNS-over-TLS resolver
systemctl enable --now snapper-timeline.timer   # BTRFS snapshots create
systemctl enable --now snapper-cleanup.timer    # BTRFS snapshots cleanup

# User services (these should be run per-user, not system-wide)
# Note: These will be started when the user logs in
systemctl --user enable pipewire.service
systemctl --user enable pipewire-pulse.service
systemctl --user enable wireplumber.service

firewall-cmd --set-default-zone=drop
