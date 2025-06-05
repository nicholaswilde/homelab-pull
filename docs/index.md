---
# :house_with_garden: Homelab Pull :muscle:

[![task](https://img.shields.io/badge/Task-Enabled-brightgreen?style=for-the-badge&logo=task&logoColor=white)](https://taskfile.dev/#/)
[![ci](https://img.shields.io/github/actions/workflow/status/nicholaswilde/homelab-pull/ci.yaml?label=ci&style=for-the-badge&branch=main)](https://github.com/nicholaswilde/homelab-pull/actions/workflows/ci.yaml)

An [ansible-pull][1] repo for my [homelab][2].

---

## :pushpin: TL;DR

### :card_file_box: Repo

!!! code

    ```shell
    cp host_vars/.template.yaml.tmpl host_vars/<hostname>.yaml
    ```

Edit `host_vars/<hostname>.yaml`

### :computer: Managed Node

!!! code

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

!!! code

    ```
    export PATH=$PATH:$HOME/.local/bin
    ```

Run `ansible-pull`.

!!! code

    ```
    ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
    ```

---

## :frame_with_picture: Background

I'm currently using [ansible][12] to push configurations to my homelab containers via SSH. See my [Homelab Playbooks][5] repo.

This repo is meant to be a test of using GitOps, similar to [Flux CD][6], to configure my homelab by having each container pull this repo periodically and run ansible locally. Pros of this method are discussed in this [Learn Linux TV video][4].

A downside is that `ansible-pull` needs to be installed on all containers, thus taking up resources, which goes against my general homelab methodology.

Container specific updates are handled using a Taskfile located on the container. The upgrades are configured in my [homelab repo][9] and are periodically triggered by this repo.

---

## :bulb: Inspiration

Inspiration for this repository has been taken from [jktr/ansible-pull-example][11].

---

## :scales: License

​[​Apache License 2.0](https://github.com/nicholaswilde/homelab-pull/raw/refs/heads/main/LICENSE)

## :pencil:​Author

​This project was started in 2025 by [​Nicholas Wilde​][3].

## :link: References

[1]: <https://docs.ansible.com/ansible/latest/cli/ansible-pull.html>
[2]: <https://nicholaswilde.io/homelab>
[3]: <https://nicholaswilde.io>
[4]: <https://www.youtube.com/watch?v=sn1HQq_GFNE>
[5]: <https://github.com/nicholaswilde/homelab-playbooks>
[6]: <https://fluxcd.io/>
[7]: <https://github.com/settings/keys>
[8]: <https://docs.ansible.com/ansible/latest/vault_guide/vault.html>
[9]: <https://github.com/nicholaswilde/homelab>
[10]: <https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html>
[11]: <https://github.com/jktr/ansible-pull-example>
[12]: <https://www.redhat.com/en/ansible-collaborative>
