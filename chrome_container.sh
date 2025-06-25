#!/usr/bin/bash -ex
sudo dnf group install -y --setopt=group_package_types=mandatory --setopt=install_weak_deps=False \
  gnome-desktop --exclude=gnome-boxes,gnome-connection,gnome-software
sudo dnf group install -y multimedia
sudo dnf install -y langpacks-cs langpacks-en
sudo dnf install -y vim crudini

# Google Chrome
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install -y google-chrome-stable

# Set vulkan/vaapi
sudo dnf install -y vulkan-tools libva-utils

# Disable 32bit packages
sudo crudini --set /etc/dnf/dnf.conf main excludepkgs "*.i?86"
