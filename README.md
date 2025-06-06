# :house_with_garden: Homelab Pull :muscle:
[![task](https://img.shields.io/badge/task-enabled-brightgreen?logo=task&logoColor=white&style=for-the-badge)](https://taskfile.dev/)

An [ansible-pull][1] repo for my [homelab][3].

---

## :pushpin: TL;DR

### :card_file_box: Repo

```shell
cp host_vars/.template.yaml.tmpl host_vars/<hostname>.yaml
```

Edit `host_vars/<hostname>.yaml`

### :computer: Managed Node

```shell
(
  sudo apt update && \
  sudo apt install -y curl && \
  OWNER_NAME="nicholaswilde" && \
  REPO_NAME="homelab-pull" && \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/${OWNER_NAME}/${REPO_NAME}/refs/heads/main/scripts/bootstrap.sh)"
)
```

Optionally, add ~/.local/bin to `PATH`.

```
export PATH=$PATH:$HOME/.local/bin
```

Run `ansible-pull`.

```
ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
```

---

## :book: Documentation

Documentation can be found [here][12].

---

## :framed_picture: Background

I'm currently using [ansible][3] to push configurations to my homelab containers via SSH. See my [Homelab Playbooks][5] repo.

This repo is meant to be a test of using GitOps, similar to [Flux CD][6], to configure my homelab by having each container pull this repo periodically and run ansible locally. Pros of this method are discussed in this [Learn Linux TV video][4].

A downside is that `ansible-pull` needs to be installed on all containers, thus taking up resources, which goes against my general homelab methodology.

Container specific updates are handled using a Taskfile located on the container. The upgrades are configured in my [homelab repo][9] and are periodically triggered by this repo.

---

## :bulb: Inspiration

Inspiration for this repository has been taken from [jktr/ansible-pull-example][11].

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
[8]: <https://docs.ansible.com/ansible/latest/vault_guide/vault.html>
[9]: <https://github.com/nicholaswilde/homelab>
[10]: <https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html>
[11]: <https://github.com/jktr/ansible-pull-example>
[12]: <https://nicholaswilde.io/homelab-pull>