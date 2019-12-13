configs
=======

Server packages
---------------
$ rpm-ostree install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
$ rpm-ostree install ansible crontabs duperemove gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly lm_sensors java-1.8.0-openjdk mmv samba sane-backends-daemon simple-scan splix mc htop smartmontools tmux unrar vim youtube-dl


Ansible playbooks
-----------------

```
$ ansible-playbook playbooks/laptop.yml -e "var_user=USER" --ask-become-pass
$ ansible-playbook playbooks/server.yml -e "var_user=USER var_cifsname=USER var_cifspass=PASS var_serverip=IP" --ask-become-pass
```
