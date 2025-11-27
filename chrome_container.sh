#!/usr/bin/bash -ex

# Install Langpacks
sudo dnf install -y --nodocs langpacks-cs langpacks-en

# Google Chrome & Firefox
sudo dnf install -y --nodocs fedora-workstation-repositories
sudo sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/google-chrome.repo
sudo dnf install -y --nodocs google-chrome-stable
sudo dnf install -y --nodocs firefox

# Set vulkan/vaapi
rpm -q rpmfusion-nonfree-release || \
  sudo dnf install -y --nodocs https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y --nodocs intel-media-driver.x86_64
