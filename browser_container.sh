#!/usr/bin/bash -ex

sudo dnf install -y langpacks-cs langpacks-en
sudo dnf group install -y multimedia
sudo dnf group install -y firefox
distrobox-export --app firefox
