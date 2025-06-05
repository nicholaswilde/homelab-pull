# :pencil: Usage

On the managed node that you'd like to run the playbook.

```shell
ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
```

!!! note

    The comma `,` is required after `$(uname -n)`

Sometimes the `tpm` doesn't install automatically and so it can be installed manually.

1. Run `tmux`.
2. Press `Ctrl + b + I`
 
A `homelab-pull` service and timer are installed to periodically run the playbook.

View the logs.

```shell
journalctl -xeu homelab-pull
```
