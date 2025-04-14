# :house_with_garden: Homelab Pull :muscle:
[![task](https://img.shields.io/badge/task-enabled-brightgreen?logo=task&logoColor=white&style=for-the-badge)](https://taskfile.dev/)

An [ansible-pull][1] repo for my homelab.

---

## :framed_picture: Background

I'm currently using [ansible][3] to push configurations to my homelab containers via SSH. See my [Homelab Playbooks][5] repo.

This repo is meant to be a test of using GitOps, similar to [Flux CD][6], to configure my homelab by having each container pull this repo and run ansible locally. Pros of this method are discussed in this [Learn Linux TV video][4].

A downside is that `ansible-pull` needs to be installed on all containers, thus taking up resources, which goes against my general homelab methodology.

---

## :hammer_and_wrench: Installation

Install `ansible-core` and `git` on the container.

```shell
sudo apt update
sudo apt install git ansible-core
```

Setup any credentials that are needed to connect to the repo.

Generate SSH keys and accept defaults.

```shell
ssh-keygen
```

Add to [GitHub keys][7].

---

## :gear: Config

Find the hostname of the remote.

```shell
uname -n
# test-debian-1
```

Create a `host_vars` file with the file name as the hostname, e.g. `host_vars/test-debian-1.yaml`

Add the groups the host is a part of to the `pull_groups` list.

```yaml
---
ansible_user: root
pull_groups:
  - lxcs
```

---

## :pencil: Usage

On the host that you'd like to run the playbook.

```shell
sudo ansible-pull -U git@github.com:nicholaswilde/homelab-pull.git -i "$(uname -n),"
```

>[!NOTE]
> The comma `,` is required after `$(uname -n)`
 
---

## :balance_scale: License

​[​Apache License 2.0](./LICENSE)

---

## :pencil:​ Author

​This project was started in 2025 by [Nicholas Wilde][2].

[1]: <https://docs.ansible.com/ansible/latest/cli/ansible-pull.html>
[2]: <https://github.com/nicholaswilde/>
[3]: <https://nicholaswilde.io/homelab>
[4]: <https://www.youtube.com/watch?v=sn1HQq_GFNE>
[5]: <https://github.com/nicholaswilde/homelab-playbooks>
[6]: <https://fluxcd.io/>
[7]: <https://github.com/settings/keys>
