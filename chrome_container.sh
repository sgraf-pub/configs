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

# Enable HW acceleration
rpm -q rpmfusion-nonfree-release || \
  sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo crudini --set /etc/yum.repos.d/rpmfusion-nonfree.repo rpmfusion-nonfree includepkgs intel-media-driver
sudo crudini --set /etc/yum.repos.d/rpmfusion-nonfree-updates.repo rpmfusion-nonfree-updates includepkgs intel-media-driver
sudo dnf install -y intel-media-driver
