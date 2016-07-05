configs
=======

Deps
----

ansible libselinux-python python-dnf

Ansible playbooks
-----------------

```
$ ansible-playbook laptop.yml -e "var_user=USER var_cifsname=USER var_cifspass=PASS var_serverip=IP"
$ ansible-playbook acrobat-reader.yml
$ ansible-playbook flash-plugin.yml
$ ansible-playbook google-talk.yml
$ ansible-playbook gtile.yml -e "var_user=USER"
$ ansible-playbook chrome.yml -e "var_user=USER"
$ ansible-playbook chromium.yml -e "var_user=USER"
$ ansible-playbook power-custom.yml
$ ansible-playbook skype.yml
$ ansible-playbook wine.yml
```
