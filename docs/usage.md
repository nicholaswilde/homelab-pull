# :pencil: Usage

On the managed node that you'd like to run the playbook.

!!! code

    ```shell
    ansible-pull -U https://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n),"
    ```

!!! note

    The comma `,` is required after `$(uname -n)`

## :simple-tmux: tpm

Sometimes the `tpm` doesn't install automatically and so it can be installed manually.

1. Run `tmux`.
2. Press `Ctrl + b + I`
 
A `homelab-pull` service and timer are installed to periodically run the playbook.

## :bookmark: Tags

Individual task files can be tested by using tags, such as `tmux`.

!!! abstract ""

    ```yaml
    - name: Setup tmux
      ansible.builtin.include_tasks: 
        file: "tmux.yaml"
        apply:
          tags:
            - tmux
      tags:
        - always
    ```

!!! code "Tag `tmux`"

    ```shell
    ansible-pull --tags tmux -U http://github.com/nicholaswilde/homelab-pull.git -i "$(uname -n)," 
    ```

## :file_folder: Logs

View the logs.

!!! code

    ```shell
    journalctl -xeu homelab-pull
    ```
