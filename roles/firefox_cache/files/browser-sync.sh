#!/bin/bash
# Syncs Browser Caches between SSD and RAM

# Define browser configurations
# Format: "BrowserName:CacheDirName"
BROWSERS=(
    "Firefox:mozilla/firefox"
    "Chrome:google-chrome"
    "Chromium:chromium"
)

RAM_BASE="/run/user/$(id -u)"
DISK_BASE="$HOME/.cache"

do_sync() {
    local browser_name=$1
    local cache_rel_path=$2
    
    local ram_dir="$RAM_BASE/$browser_name-cache"
    local disk_dir="$DISK_BASE/$cache_rel_path"
    local disk_persistent_dir="$DISK_BASE/$cache_rel_path-persistent"

    # Check if the browser cache exists or if we have a persistent backup
    # If neither exists, we assume the browser is not installed or not used, so we skip.
    if [ ! -d "$disk_dir" ] && [ ! -d "$disk_persistent_dir" ]; then
        return
    fi
    
    case "$3" in
        start)
            # 1. Ensure our persistent disk backup exists
            # We move the existing cache to persistent if persistent doesn't exist
            if [ -d "$disk_dir" ] && [ ! -L "$disk_dir" ] && [ ! -d "$disk_persistent_dir" ]; then
                 mv "$disk_dir" "$disk_persistent_dir"
            fi
            
            mkdir -p "$disk_persistent_dir"
            
            # 2. Ensure our RAM directory exists
            mkdir -p "$ram_dir"
            
            # 3. Copy saved data from SSD into RAM
            # Only do this if ram_dir is empty to avoid overwriting current session if script keeps running? 
            # Actually rsync is safe.
            rsync -a --delete "$disk_persistent_dir/" "$ram_dir/"
            
            # 4. Remove the old cache folder (if it's not a link) and replace it with a symlink to RAM
            if [ ! -L "$disk_dir" ]; then
                rm -rf "$disk_dir"
            fi
            
            # Update the symlink just in case
            if [ "$(readlink -f "$disk_dir")" != "$ram_dir" ]; then
                rm -f "$disk_dir"
                ln -s "$ram_dir" "$disk_dir"
            fi
            ;;
            
        stop|sync)
            # 1. Save data from RAM back to the SSD
            if [ -d "$ram_dir" ]; then
                rsync -a --delete "$ram_dir/" "$disk_persistent_dir/"
            fi
            ;;
    esac
}

case "$1" in
    start|stop|sync)
        for browser_info in "${BROWSERS[@]}"; do
            IFS=':' read -r name path <<< "$browser_info"
            do_sync "$name" "$path" "$1"
        done
        ;;
        
    *)
        echo "Usage: $0 {start|stop|sync}"
        exit 1
esac
