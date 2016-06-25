configs
=======

Deps
----

ansible libselinux-python python-dnf

Ansible playbooks
-----------------

```
$ ansible-playbook -i production laptop.yml -e "var_user=USER" -e "var_cifsname=USER" -e "var_cifspass=PASS" -e "var_serverip=IP"
$ ansible-playbook -i production acrobat-reader.yml
$ ansible-playbook -i production flash-plugin.yml
$ ansible-playbook -i production google-talk.yml
$ ansible-playbook -i production gtile.yml -e "var_user=USER"
$ ansible-playbook -i production chrome.yml -e "var_user=USER"
$ ansible-playbook -i production chromium.yml -e "var_user=USER"
$ ansible-playbook -i production skype.yml
$ ansible-playbook -i production wine.yml
```
