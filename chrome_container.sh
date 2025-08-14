#!/usr/bin/bash -ex

# Disable 32bit packages
sudo dnf remove -y '*.i686'
sudo dnf install -y crudini
sudo crudini --ini-options=nospace --set /etc/dnf/dnf.conf main excludepkgs "*.i?86"

# Install Langpacks
sudo dnf install -y langpacks-cs langpacks-en

# Install vim
sudo dnf install -y vim

# Google Chrome
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install -y google-chrome-stable

# Set vulkan/vaapi
sudo dnf install -y vulkan-tools libva-utils
rpm -q rpmfusion-nonfree-release || \
  sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo crudini --ini-options=nospace --set /etc/yum.repos.d/rpmfusion-nonfree.repo rpmfusion-nonfree includepkgs "intel-media-driver.x86_64,rpmfusion-nonfree-release.noarch"
sudo crudini --ini-options=nospace --set /etc/yum.repos.d/rpmfusion-nonfree-updates.repo rpmfusion-nonfree-updates includepkgs "intel-media-driver.x86_64,rpmfusion-nonfree-release.noarch"
sudo dnf install -y intel-media-driver.x86_64
