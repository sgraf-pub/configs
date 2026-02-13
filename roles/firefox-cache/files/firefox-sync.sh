#!/bin/bash
# Syncs Firefox Cache between SSD and RAM

# Define our directories
RAM_DIR="/run/user/$(id -u)/firefox-cache"
DISK_DIR="$HOME/.cache/mozilla/firefox-persistent"
LINK_DIR="$HOME/.cache/mozilla/firefox"

case "$1" in
    start)
        # 1. Ensure our persistent disk backup exists
        mkdir -p "$DISK_DIR"
        # 2. Ensure our RAM directory exists
        mkdir -p "$RAM_DIR"
        
        # 3. Copy saved data from SSD into RAM
        rsync -a --delete "$DISK_DIR/" "$RAM_DIR/"
        
        # 4. Remove the old cache folder and replace it with a symlink to RAM
        rm -rf "$LINK_DIR"
        ln -s "$RAM_DIR" "$LINK_DIR"
        ;;
        
    stop|sync)
        # 1. Save data from RAM back to the SSD
        if [ -d "$RAM_DIR" ]; then
            rsync -a --delete "$RAM_DIR/" "$DISK_DIR/"
        fi
        ;;
        
    *)
        echo "Usage: $0 {start|stop|sync}"
        exit 1
esac
