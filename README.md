configs
=======

Server packages
---------------
$ rpm-ostree install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
$ rpm-ostree install abcde ansible crontabs duperemove ffmpeg htop java-1.8.0-openjdk lame lm_sensors mc mmv python3-eyed3 samba sane-backends-daemon smartmontools splix tmux unrar vim vobcopy youtube-dl


Ansible playbooks
-----------------

```
$ ansible-playbook playbooks/laptop.yml -e "var_user=USER" --ask-become-pass
$ ansible-playbook playbooks/server.yml -e "var_user=USER var_cifsname=USER var_cifspass=PASS var_serverip=IP" --ask-become-pass
```
