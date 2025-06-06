# :books:Collections

To reduce the amount space needed on each of my containers, `ansible-core` installed and only the needed Ansible
[collections][1] are used.

Collections may be installed by hand beforehand, or using the `bootstrap.sh` script, but it was just easier to package
them with the repo itself.

An attempt to install the collections was made using [Ansible pretasks][2], but ended up running into issues where
Ansible would complain about not having the required collections installed before it even got to executing the pretasks.

[1]: <https://docs.ansible.com/ansible/latest/collections_guide/index.html>
[2]: <https://www.redhat.com/en/blog/ansible-pretasks-posttasks>
