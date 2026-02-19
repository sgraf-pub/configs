#!/usr/bin/bash -ex

# Install Langpacks
sudo dnf install -y langpacks-cs langpacks-en
sudo dnf group install -y multimedia

# Google Chrome & Firefox
sudo cp ~/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
sudo dnf install -y google-chrome-stable
sudo dnf install -y firefox
