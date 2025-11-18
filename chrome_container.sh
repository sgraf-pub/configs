#!/usr/bin/bash -ex

# Install Langpacks
sudo microdnf install -y langpacks-cs langpacks-en

# Google Chrome & Firefox
sudo microdnf install -y fedora-workstation-repositories
sudo sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/google-chrome.repo
sudo microdnf install -y google-chrome-stable
sudo microdnf install -y firefox

# Set vulkan/vaapi
rpm -q rpmfusion-nonfree-release || \
  sudo microdnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo microdnf install -y intel-media-driver.x86_64
