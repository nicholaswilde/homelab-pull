# Homelab Pull
[![task](https://img.shields.io/badge/task-enabled-brightgreen?logo=task&logoColor=white&style=for-the-badge)](https://taskfile.dev/)

An [ansible-pull][1] repo for my homelab.

---

## :framed_picture: Background

I'm currently using [ansible][3] to push configurations to my homelab containers via SSH. See my [Homelab Playbooks][5] repo.

This repo is meant to be a test of using GitOps, similar to [Flux CD][6], to configure my homelab. Pros of this method are discussed in this [Learn Linux TV video][4].

A downside is that asible-pull will need to be installed on all containers, thus taking up resources, which goes against my general homelab methodology.

---

## :gear: Config

WIP

---

## :pencil: Usage

WIP

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