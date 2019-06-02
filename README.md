configs
=======

Deps
----

ansible libsemanage-python libselinux-python python-dnf

Ansible playbooks
-----------------

```
$ ansible-playbook playbooks/laptop.yml -e "var_user=USER"
$ ansible-playbook playbooks/hosts.yml
$ ansible-playbook playbooks/power-laptop.yml
```
