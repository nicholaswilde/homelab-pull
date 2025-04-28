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

### :computer: Host

```shell
(
  sudo apt update && \
  sudo apt install curl && \
  bash -c "$(curl -fsSL https://github.com/nicholaswilde/homelab-pull/raw/refs/heads/main/scripts/bootstrap.sh)" && \
  ~/.local//bin/ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
)
```

---

## :framed_picture: Background

I'm currently using [ansible][3] to push configurations to my homelab containers via SSH. See my [Homelab Playbooks][5] repo.

This repo is meant to be a test of using GitOps, similar to [Flux CD][6], to configure my homelab by having each container pull this repo periodically and run ansible locally. Pros of this method are discussed in this [Learn Linux TV video][4].

A downside is that `ansible-pull` needs to be installed on all containers, thus taking up resources, which goes against my general homelab methodology.

Container specific updates are handled using a Taskfile located on the container. The upgrades are configured in my [homelab repo][9] and are periodically triggered by this repo.

---

## :hammer_and_wrench: Installation

### :paperclips: Dependencies

Install dependencies on the host.

```shell
sudo apt update
sudo apt install curl
```

### :hiking_boot: Bootstrap

Use the bootstrap script to finish setting up the host.

>[!WARNING]
>Always inspect a shell script before running it!

```shell
bash -c "$(curl -fsSL https://github.com/nicholaswilde/homelab-pull/raw/refs/heads/main/scripts/bootstrap.sh)"
```

Add the `pipx` `bin` dir temporarily to `PATH`.

```shell
export PATH=$PATH:$HOME/.local/bin
```

Alternatively, add it permanently to `.bashrc`.

```shell
(
  echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc && \
  source ~/.bashrc
)
```

---

## :gear: Config

Find the hostname of the remote.

```shell
uname -n
# test-debian-1
```

Create a `host_vars` file with the file name as the hostname, e.g. `host_vars/test-debian-1.yaml`.

```shell
cp host_vars/.template.yaml.tmpl host_vars/<hostname>.yaml
```

Add the groups the host is a part of to the `pull_groups` list.

```yaml
---
ansible_user: root
pull_groups:
  - lxcs
```

Create additional roles if needed.

Update `playbook.yml` with which host groups run which roles.

Update variables that being passed into each role. List of variables can be found under `roles/<role name>/defaults/main.yaml`.

---

## :lock: Secrets

### :bank: Ansible Vault

Secrets are encrypted in variable files as strings using [`ansible-vault`][8] and a password file.

A password file can be generated via the command line.

```shell
mkdir -p ~/.config/homelab-pull/
printf %s "mypassword" > ~/.config/homelab-pull/password
```

Or generate a random password.

```shell
openssl rand -base64 32 > ~/.config/homelab-pull/password
```

Use the password file by passing in the `--vault-password-file` argument.

The password file can be set in the `ansible.cfg` file using the `vault_password_file` variable.

```ini
[defaults]
vault_password_file = ~/.config/homelab-pull/password
```

The password file then can be used to encrypt a string value `bar` with name `foo`.

```shell
echo "bar" | ansible-vault encrypt_string --vault-password-file ~/.config/homelab-pull/password --stdin-name foo
```

```yaml
foo: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66323735363831366563616235633231666231356535633464313833663732393639333864353662
          3764393232323138313534356336626333376431383065630a333536346664303633323937623361
          36643539366333656239333262333331663533623931616362353264666437336136386364613666
          3066343132653532660a393138663265316262366638313664323835626263653738613132393836
          6336
```

>[!NOTE]
>If `vault_password_file` is set in `ansible.cfg` and the above command is run inside the repo directory, the `--vault-password-file` argument does not need to be passed to the `ansible-vault` command.

Save the output to a vars yaml file, such as `group_vars/all.yaml`

### :lock: LastPass or Bitwarden

WIP

---

## :pencil: Usage

On the host that you'd like to run the playbook.

```shell
ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
```

>[!NOTE]
> The comma `,` is required after `$(uname -n)`
 
A `homelab-pull` service and timer are installed to periodically run the playbook.

View the logs.

```shell
journalctl -xeu homelab-pull
```

---

## :whale2: Testing Using Docker

Launch into a shell in a Debian Docker container.

```shell
docker run -it --rm -h "$(uname -n)" debian /bin/bash
```

In the Docker container.

```shell
cd ~ && \
apt update && \
apt install curl -y && \
bash -c "$(curl -fsSL https://github.com/nicholaswilde/homelab-pull/raw/refs/heads/main/scripts/bootstrap.sh)" && \
export PATH=$PATH:$HOME/.local/bin
```

Test the playbook.

```shell
ansible-pull -U http://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
```

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
