configs
=======

Deps
----

ansible libsemanage-python libselinux-python python-dnf

Ansible playbooks
-----------------

```
$ ansible-playbook playbooks/laptop.yml -e "var_user=USER var_cifsname=USER var_cifspass=PASS var_serverip=IP"
$ ansible-playbook playbooks/acrobat-reader.yml
$ ansible-playbook playbooks/flash-plugin.yml
$ ansible-playbook playbooks/google-talk.yml
$ ansible-playbook playbooks/gtile.yml -e "var_user=USER"
$ ansible-playbook playbooks/hosts.yml
$ ansible-playbook playbooks/chrome.yml -e "var_user=USER"
$ ansible-playbook playbooks/chromium.yml -e "var_user=USER"
$ ansible-playbook playbooks/lxde.yml -e "var_user=USER"
$ ansible-playbook playbooks/power-custom.yml
$ ansible-playbook playbooks/power-laptop.yml
$ ansible-playbook playbooks/skype.yml
$ ansible-playbook playbooks/wine.yml
```
