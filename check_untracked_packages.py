#!/usr/bin/env python3

import os
import yaml
import subprocess
import sys

def get_ansible_packages(roles_dir):
    packages = set()
    for root, dirs, files in os.walk(roles_dir):
        for file in files:
            if file.endswith(('.yml', '.yaml')):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r') as f:
                        data = yaml.safe_load(f)
                        if isinstance(data, list):
                            for task in data:
                                if not isinstance(task, dict):
                                    continue
                                
                                # Look for package modules
                                pkg_module = None
                                for mod in ['ansible.builtin.dnf', 'ansible.builtin.yum', 'ansible.builtin.package', 'dnf', 'yum', 'package']:
                                    if mod in task:
                                        pkg_module = task[mod]
                                        break
                                
                                if pkg_module:
                                    names_to_add = []
                                    if isinstance(pkg_module, dict) and 'name' in pkg_module:
                                        names = pkg_module['name']
                                        if isinstance(names, str):
                                            names_to_add.append(names)
                                        elif isinstance(names, list):
                                            names_to_add.extend(names)
                                    elif isinstance(pkg_module, list):
                                        names_to_add.extend(pkg_module)
                                    elif isinstance(pkg_module, str):
                                        # Handle legacy string arguments: "name=htop state=present"
                                        for part in pkg_module.split():
                                            if part.startswith("name="):
                                                names_to_add.append(part.split("=", 1)[1])
                                                
                                    for name in names_to_add:
                                        # Filter out variables if any exist
                                        if isinstance(name, str) and "{{" not in name:
                                            packages.add(name)
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")
    return packages

def get_system_installed_packages():
    print("Querying dnf history to parse your explicit manual terminal commands...")
    try:
        # Get all transaction IDs
        hist_list = subprocess.run(['dnf', 'history', 'list'], capture_output=True, text=True, check=True)
        tx_ids = []
        for line in hist_list.stdout.split('\n'):
            parts = line.strip().split()
            if parts and parts[0].isdigit():
                tx_ids.append(int(parts[0]))

        suspected_packages = {}
        print(f"Scanning {len(tx_ids)} history transactions for explicit 'install' commands...")
        
        # Batch queries to speed up execution
        chunk_size = 200
        for i in range(0, len(tx_ids), chunk_size):
            chunk = tx_ids[i:i+chunk_size]
            cmd = ['dnf', 'history', 'info'] + [str(x) for x in chunk]
            hist_info = subprocess.run(cmd, capture_output=True, text=True)
            
            current_tx_id = None
            for line in hist_info.stdout.split('\n'):
                line = line.strip()
                lower_line = line.lower()
                
                if lower_line.startswith('transaction id') or lower_line.startswith('transaction'):
                    # e.g., "Transaction ID : 123" or "Transaction : 123"
                    parts = line.split(':')
                    if len(parts) > 1:
                        try:
                            # Extract the first word which should be the ID
                            id_str = parts[1].strip().split()[0]
                            current_tx_id = int(id_str)
                        except ValueError:
                            pass
                
                elif lower_line.startswith('command') or lower_line.startswith('description'):
                    if not current_tx_id:
                        continue
                        
                    if ':' in line:
                        cmdline = line.split(':', 1)[-1].strip()
                    else:
                        cmdline = line.strip()
                    words = cmdline.split()
                    
                    if 'kiwi_dnf5.conf' in cmdline:
                        current_tx_id = None
                        continue

                    if 'install' in words or 'in' in words:
                        for w in words:
                            if not w.startswith('-') and w not in ('dnf', 'sudo', 'install', 'in') and not w.endswith('.rpm'):
                                suspected_packages[w] = current_tx_id
                                
                    current_tx_id = None

        # Verify which of these explicitly requested packages are currently installed
        print("Verifying which suspected packages are still installed on the system...")
        
        # Batch RPM queries as well
        installed = {}
        suspects_list = list(suspected_packages.keys())
        for i in range(0, len(suspects_list), chunk_size):
            chunk = suspects_list[i:i+chunk_size]
            res = subprocess.run(['rpm', '-q', '--qf', '%{NAME}\\n'] + chunk, capture_output=True, text=True)
            # Ignore returncode since it will be non-zero if some packages are not installed
            for line in res.stdout.strip().split('\n'):
                line = line.strip()
                # rpm -q outputs "package X is not installed" for missing ones
                if line and not line.endswith('is not installed'):
                    # The name returned is the actual RPM name
                    # Find which suspected package this corresponds to (it usually matches exactly)
                    # For simplicity, we just add the reported name and use a generic tx_id if we can't match it
                    tx_id = suspected_packages.get(line, suspected_packages.get(chunk[0])) # approximation
                    installed[line] = tx_id

        return installed
    except subprocess.CalledProcessError as e:
        print(f"Error querying dnf history: {e}")
        return {}
    except FileNotFoundError:
        print("Error: 'dnf' command not found. This script must be run on a system with dnf installed.")
        return {}

def main():
    # Attempt to find roles directories
    roles_dirs = ['roles']
    if len(sys.argv) > 1:
        roles_dirs = sys.argv[1:]
        
    for d in roles_dirs:
        if not os.path.isdir(d):
            print(f"Error: '{d}' directory not found.")
            print(f"Usage: {sys.argv[0]} [dir1] [dir2] ...")
            return

    ansible_packages = set()
    for d in roles_dirs:
        print(f"Parsing Ansible roles in '{d}'...")
        ansible_packages.update(get_ansible_packages(d))
        
    print(f"Found {len(ansible_packages)} hardcoded packages defined across all Ansible roles.")
    
    installed_packages = get_system_installed_packages()
    if not installed_packages:
        print("No user-installed packages found or error querying dnf.")
        return
        
    print(f"Found {len(installed_packages)} packages installed explicitly by the user.")
    
    # Compare
    untracked_packages = {pkg: tx_id for pkg, tx_id in installed_packages.items() if pkg not in ansible_packages}
    
    if not untracked_packages:
        print("\nAll user-installed packages are tracked in Ansible! Great job!")
        return
        
    print(f"\nFound {len(untracked_packages)} packages that are installed but NOT in Ansible:")
    for pkg in sorted(untracked_packages.keys()):
        tx_id = untracked_packages[pkg]
        print(f"  - {pkg} (History ID: {tx_id})")
        
    print("\nDo you want to review and uninstall these packages interactively? [y/N]")
    try:
        choice = input().strip().lower()
        if choice == 'y':
            for pkg in sorted(untracked_packages):
                print(f"\nUninstall '{pkg}'? [y/N/q (quit)]")
                action = input().strip().lower()
                if action == 'q':
                    break
                elif action == 'y':
                    print(f"Removing {pkg}...")
                    subprocess.run(['sudo', 'dnf', 'remove', '-y', pkg])
    except KeyboardInterrupt:
        print("\nOperation cancelled.")
                
if __name__ == "__main__":
    main()
